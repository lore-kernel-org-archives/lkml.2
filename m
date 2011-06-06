Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1FFQh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:37:28 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.65.40]:65469 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1FFQhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:37:24 -0400
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
In-Reply-To: <BANLkTi=WGCrT3Z5qar0P-EqN=aKn9z-HYA@mail.gmail.com>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
	 <1307133252-23259-3-git-send-email-wad@chromium.org>
	 <BANLkTink868yzHYHd-FyK9BH6nybdSUCuA@mail.gmail.com>
	 <1307364487.2876.18.camel@moss-pluto>
	 <BANLkTi=WGCrT3Z5qar0P-EqN=aKn9z-HYA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Mon, 06 Jun 2011 12:36:17 -0400
Message-ID: <1307378177.2876.32.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 11:25 -0400, Colin Walters wrote:
> On Mon, Jun 6, 2011 at 8:48 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
> >
> > Suppose we did add a MAC check on enabling seccomp.  Under what
> > circumstances would we want to deny a process the ability to further
> > restrict its own actions?
> 
> Well, I could understand a simple argument about limiting the exposed
> kernel API; again I know this is sort of ironic, but seccomp is a
> pretty complex new API, and there will be processes that *aren't*
> using it for whatever reason and might be exploited.
> 
> I'm not arguing strongly for this, I just wanted to bring it up.  The
> set of hooks seems rather inconsistent right now.
> 
> Given the above rationale, why for example is there a SELinux access
> vector for sched_getscheduler (process:getsched)?

That can be invoked on a target process other than current, right?
Any operation that enables a process to observe or modify the state of
another process requires a MAC check.

> > The situation would differ if seccomp could be enabled for a different
> > target process than current, or if it could be inherited across exec.
> 
> It's based on prctl() so only affects the current process, and as for
> the latter - it looks like the current state is that if seccomp is
> active, exec is always disallowed.

Right, so I don't think it requires a MAC check presently.

-- 
Stephen Smalley
National Security Agency

