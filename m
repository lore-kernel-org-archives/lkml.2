Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757087Ab1FFM4F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 08:56:05 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:40548 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab1FFM4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:56:03 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jun 2011 08:56:02 EDT
Subject: Re: [PATCH v4 03/13] seccomp_filters: new mode with configurable
 syscall filters
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Colin Walters <walters@verbum.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-security-module@vger.kernel.org
In-Reply-To: <BANLkTink868yzHYHd-FyK9BH6nybdSUCuA@mail.gmail.com>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
	 <1307133252-23259-3-git-send-email-wad@chromium.org>
	 <BANLkTink868yzHYHd-FyK9BH6nybdSUCuA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Mon, 06 Jun 2011 08:48:07 -0400
Message-ID: <1307364487.2876.18.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 18:16 -0400, Colin Walters wrote:
> On Fri, Jun 3, 2011 at 4:34 PM, Will Drewry <wad@chromium.org> wrote:
> > (Any thoughts specifically on the mutex use would be greatly appreciated!)
> >
> > This change adds a new seccomp mode which specifies the allowed system
> > calls dynamically.
> 
> One thing to consider (not sure if it's been discussed, but I think
> not) is whether some of the LSMs should hook this.
> 
> Notably, it looks like SELinux doesn't have an access vector for prctl
> at all now; it doesn't hook task_prctl from what I see, and so we fall
> back to cap_task_prctl.  While I know the idea of restricting a
> process' ability to enter seccomp is a bit perverse, we should
> probably at least allow mandatory controls.  James?

I may be missing something, but so long as seccomp can only be enabled
by a process on itself and is not inherited across exec (or as in this
case prohibits exec), then I don't see why MAC systems should care.

Suppose we did add a MAC check on enabling seccomp.  Under what
circumstances would we want to deny a process the ability to further
restrict its own actions?

Denying the ability to enable seccomp could itself lead to
vulnerabilities, as applications have shown that they often fail to
check or handle errors from privilege-limiting calls correctly.

The situation would differ if seccomp could be enabled for a different
target process than current, or if it could be inherited across exec.

-- 
Stephen Smalley
National Security Agency

