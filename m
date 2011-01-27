Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1A0ODK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 09:03:10 -0500
Received: from adelie.canonical.com ([91.189.90.139]:51179 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1A0ODI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 09:03:08 -0500
Date: Thu, 27 Jan 2011 08:02:55 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Eric Paris <eparis@redhat.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, sgrubb@redhat.com
Subject: Re: [PATCH] System Wide Capability Bounding Set
Message-ID: <20110127140255.GB2935@localhost>
References: <1294266337.3237.45.camel@localhost.localdomain>
 <20110111220201.GA6446@localhost>
 <1295034658.2816.16.camel@localhost.localdomain>
 <AANLkTik07sOb8oQThFPLvAnQLXbyPJ+oqtqE2SMX2erk@mail.gmail.com>
 <1295645135.3403.31.camel@localhost.localdomain>
 <AANLkTinPGMijRFnn8T=fndnCCGAsNq_6qCOzKcuhZE8H@mail.gmail.com>
 <20110124214018.GA8395@hallyn.com>
 <1296084856.2534.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296084856.2534.18.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> At this point it seems to me like what I must do is add a way for a task
> with enough priv to force caps out of the bset and pI of the kthread
> which upcalls to run userspace programs.  Thus when the kthread runs a
> program it cannot give those privs....

Exactly, that's what I was envisioning.

How about adding an optional kthread-wrapper program which, when
specified on the boot cmdline, will be the program to wrap any
userspace programs which the kernel executes?  Then that program
can do the work it needs to remove capabilities from pI and X,
set selinux context, etc.  Just a thought, seems somewhat more
elegant thatn hard-coding the behavior in the kernel, but not sure
it's practical.

> Does this seem reasonable?  What would such an interface look like?
> (This is scarily like the old meaning of CAP_SETPCAP....)

I'm not sure it's unreasonable, but in one sense it seems like just
walking one more step toward the end of the plank:  next, you're
going to have to worry about a kernel-spawned thread, from which you've
denied cap_sys_module, writing to /boot/initrd* the malicious steps
it wanted to take, to be executed at next boot when it still has
cap_sys_module.  (Fine, enter TPM :)

What is the attack vector you're actually envisioning?  Does some
trojan come in and overwrite a program which which it hopes the
kernel will execute?  Or is there just an existing vuln in such
a program?  Are there other ways we can address these?  Can we find
a way to classify the kernel-spawned userspace programs?  Perhaps
based on the selinux context assigned to the program, we can assign
some level of trust that noone could have modified the source?

-serge
