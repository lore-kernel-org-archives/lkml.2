Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2LUDG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 22:06:29 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:59518 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2LUDGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 22:06:23 -0500
MIME-Version: 1.0
In-Reply-To: <20121221030018.GA15032@www.outflux.net>
References: <20121221030018.GA15032@www.outflux.net>
Date: Thu, 20 Dec 2012 19:06:22 -0800
X-Google-Sender-Auth: dNg2xGTpISkEQ-ieqCXRXvGpKsM
Message-ID: <CAGXu5jJtoPdhZ_DGeaCT1AsUuLfS4LThaR0PkKbwmTG2rDPZKw@mail.gmail.com>
Subject: Re: [RFC] stack and heap are executable on x86_64
From: Kees Cook <keescook@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 7:00 PM, Kees Cook <keescook@chromium.org> wrote:
> While trying to fix test_nx, I discovered that it looks like stack and
> heap are executable again (at least on x86_64). :( I tried to bisect

Btw, this ends up looking like this on v3.4:

[    2.486223] test_nx: Testing NX protection ...
[    2.487468] test_nx: calling ffff88001dd57e45 (0xC3)
[    2.488766] test_nx: stack is executable
[    2.489802] test_nx: calling ffff88001e2c7580 (0xC3)
[    2.491106] test_nx: heap is executable
[    2.492086] test_nx: calling ffffffff81803c80 (0xC3)
[    2.493201] test_nx: calling ffffffffa0002220 (0xC3)
[    2.493843] test_nx: calling ffffffffa0001224 (0xC3)
[    2.494549] test_nx: Done testing.

-Kees

--
Kees Cook
Chrome OS Security
