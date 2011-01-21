Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1AUVZs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 16:25:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486Ab1AUVZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 16:25:46 -0500
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: Eric Paris <eparis@redhat.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, sgrubb@redhat.com
Date: Fri, 21 Jan 2011 16:25:34 -0500
In-Reply-To: <AANLkTik07sOb8oQThFPLvAnQLXbyPJ+oqtqE2SMX2erk@mail.gmail.com>
References: <1294266337.3237.45.camel@localhost.localdomain>
	 <20110111220201.GA6446@localhost>
	 <1295034658.2816.16.camel@localhost.localdomain>
	 <AANLkTik07sOb8oQThFPLvAnQLXbyPJ+oqtqE2SMX2erk@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295645135.3403.31.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-16 at 19:16 -0800, Andrew G. Morgan wrote:

> I'm not a supporter of system-wide security contexts changing under
> running programs. Previous experience has taught me that tricking a
> program into thinking it has one sort of privilege and then
> withdrawing it without notice can be dangerous.

But a bounding set doesn't affect a running program's abilities, the
bset is only applied at exec().  So if it's fcaps based you have all
that wacky kill logic.

>  Since privileged
> programs include shells that invoke privileged commands to perform
> system admin tasks, I consider a global bounding set to be trouble in
> the making. 

No question, but then again, if you have CAP_SYS_MODULE there are a lot
easier ways to make trouble   :)

> If we were to delete that special code what I think is missing from
> the current kernel model, is not a global bounding set, but a 'kernel
> auto-exec' securebits value. One that can be set by an admin at
> runtime to suppress the root-is-all-capable behavior of the auto-exec
> process, and defer the privilege escalation to carefully audited file
> capabilities on the relevant helper binaries.

But how can that leave us with an impotent root?  Root would be easily
able to craft a file with any caps it wants in fI and fP on any of the
plethora of helper programs the kernel calls and escalate away it's
impotence.

I'd really like to drop a cap from an entire system never to return.
Maybe I can get there by exposing the bset of the kthread which launches
the helpers (makes me feel very dirty).  But that is smaller than the
global bset....

-Eric

