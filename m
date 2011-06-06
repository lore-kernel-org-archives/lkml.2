Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab1FFPZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:25:22 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44542 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab1FFPZT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:25:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c3fo8ytkGGtLiTNmLs2Hbbb7GpLji9dzh0iuy8h68m7ZF/Pfu/AMmCFt34bbKAzFe0
         PRp0+ZS9v85EXj7IIRuUafJG+Joo0kMLLz17BU0lli6kNHWBQuE6c3OVibZb7RoMvTmI
         mOPRsvBj/7WxMP2o8nyXwXvLH4/yZOlj4Y7i8=
MIME-Version: 1.0
In-Reply-To: <1307364487.2876.18.camel@moss-pluto>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
	<1307133252-23259-3-git-send-email-wad@chromium.org>
	<BANLkTink868yzHYHd-FyK9BH6nybdSUCuA@mail.gmail.com>
	<1307364487.2876.18.camel@moss-pluto>
Date: Mon, 6 Jun 2011 11:25:17 -0400
X-Google-Sender-Auth: -zIDy64juWdyKh9j3ZwAeub2_Wo
Message-ID: <BANLkTi=WGCrT3Z5qar0P-EqN=aKn9z-HYA@mail.gmail.com>
Subject: Re: [PATCH v4 03/13] seccomp_filters: new mode with configurable
 syscall filters
From: Colin Walters <walters@verbum.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 6, 2011 at 8:48 AM, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>
> Suppose we did add a MAC check on enabling seccomp.  Under what
> circumstances would we want to deny a process the ability to further
> restrict its own actions?

Well, I could understand a simple argument about limiting the exposed
kernel API; again I know this is sort of ironic, but seccomp is a
pretty complex new API, and there will be processes that *aren't*
using it for whatever reason and might be exploited.

I'm not arguing strongly for this, I just wanted to bring it up.  The
set of hooks seems rather inconsistent right now.

Given the above rationale, why for example is there a SELinux access
vector for sched_getscheduler (process:getsched)?

> Denying the ability to enable seccomp could itself lead to
> vulnerabilities, as applications have shown that they often fail to
> check or handle errors from privilege-limiting calls correctly.

Right.

> The situation would differ if seccomp could be enabled for a different
> target process than current, or if it could be inherited across exec.

It's based on prctl() so only affects the current process, and as for
the latter - it looks like the current state is that if seccomp is
active, exec is always disallowed.
