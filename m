Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab2A3W7b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:59:31 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:54375 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2A3W73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:59:29 -0500
Message-ID: <4709645db4d9c608afd01b00e5fe79ae.squirrel@webmail.greenhost.nl>
In-Reply-To: <CAObL_7F-vXXbkj8-9xsrxETyUka5xQ0jD9teN_Li50QzRYZugw@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
    <1327706681-11959-2-git-send-email-wad@chromium.org>
    <c211732dcacbff72c70127ccab36122a.squirrel@webmail.greenhost.nl>
    <CABqD9hatfCSSqUt-FYUa6-LcCeDEht8gLMAY7cnWKe6gp-9upg@mail.gmail.com>
    <13b3f9dcf188908604a9529ef1934ecf.squirrel@webmail.greenhost.nl>
    <CABqD9hYXJapEiDcA_VxggkTkC6KXnJwmoE3zAoPzvYDCgkQXSA@mail.gmail.com>
    <CAObL_7F-vXXbkj8-9xsrxETyUka5xQ0jD9teN_Li50QzRYZugw@mail.gmail.com>
Date: Mon, 30 Jan 2012 23:59:03 +0100
Subject: Re: [PATCH v5 2/3] seccomp_filters: system call filtering using BPF
From: "Indan Zupancic" <indan@nul.nu>
To: "Andrew Lutomirski" <luto@mit.edu>
Cc: "Will Drewry" <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, mcgrathr@chromium.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 523f42b60907f92a5b98f162865e3e4b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, January 30, 2012 23:29, Andrew Lutomirski wrote:
> [not quoting anything because this is a more general question]
>
> How portable across architectures is this supposed to be?  At least
> syscall numbering varies widely, and calling conventions can be
> different (x86_64 has four of them, for example).  For all I know,
> argument order might be different in some cases.

Apart from the syscall numbering, it is surprisingly consistent.
For e.g. x86 about 190 out of 300/340 system calls are the same,
so about 2/3. The 1/3 that are different are mostly 32-bit only
variants of systemcalls, or obsolete ones. So for the syscall
arguments actually checked, the number is much higher.

Different argument ordering for the same syscall between archs
is very rare.

Greetings,

Indan


