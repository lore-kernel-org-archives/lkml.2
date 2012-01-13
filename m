Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2AMBMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 20:12:17 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53737 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756308Ab2AMBMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 20:12:14 -0500
MIME-Version: 1.0
In-Reply-To: <20120106201126.GA7239@kroah.com>
References: <20120106201126.GA7239@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 12 Jan 2012 17:11:53 -0800
X-Google-Sender-Auth: Jn2IC6dTeSzgxv0PqY2t-1rRYg0
Message-ID: <CA+55aFzH1cqoxr5RR8yqPdjf4XphKHk9YmcDozPn_z7Aq3nDcg@mail.gmail.com>
Subject: Re: [GIT PATCH] driver core merge for 3.3
To: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 6, 2012 at 12:11 PM, Greg KH <gregkh@suse.de> wrote:
>
> Big thing here, that caused all of the merge issues, is the removal of
> the sysdev code.  It has been long needed to be removed, Kay finally
> just did it, thankfully.  There are patches pending that take advantage
> of this, providing properly CPU hotplug driver loading support, that
> will have to wait until 3.4, as they didn't make the merge window in
> time.  Note, the sysdev code isn't removed from the tree just yet, to
> help catch any other tree that might not have noticed this in the
> linux-next merge process.  I'll send a follow-on patch after 3.3-rc1 is
> out that removes this code, after ensuring that no other in-tree code is
> using the sysdev structures.

Hmm. I think this is the cause of one of the suspend/resume problems I'm seeing:

   Device 'machinecheck3' does not have a releae() function, it is
broken and must be fixed

that's the WARN_ON() in drivers/base/core.c (line 192), and it comes
from disable_nonboot_cpus() doing the whole device_unregister() thing.

Afaik, it's arch/x86/kernel/cpu/mcheck/mce.c.

Ho humm?

                   Linus
