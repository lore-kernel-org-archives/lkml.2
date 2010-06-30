Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0F3Pla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:41:30 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43740 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0F3Pl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <20100630004027.GG4837@outflux.net>
References: <20100630003844.GE4837@outflux.net>
	<20100630004027.GG4837@outflux.net>
Date: Wed, 30 Jun 2010 11:41:26 -0400
Message-ID: <AANLkTim_RShqD7CKwjyeeGf3-1NZaVE4K2XUlrsoS1xx@mail.gmail.com>
Subject: Re: [PATCH 2/2] Yama: add PTRACE exception tracking
From: Eric Paris <eparis@parisplace.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 8:40 PM, Kees Cook <kees.cook@canonical.com> wrote:
> Some application suites have external crash handlers that depend on
> being able to use PTRACE to generate crash reports (KDE, Chromium, etc).
> Since the inferior process generally knows the PID of the debugger,
> it can use PR_SET_PTRACER to allow a specific PID and its descendants
> to perform the PTRACE instead of only a direct ancestor.
>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

any normal unpriv application:

while(1) {
        prctl(PR_SET_PTRACER, 1, 0, 0, 0);
}

watch kernel run out of memory and bring down the box.  Seems like
quite the DoS.....

-Eric
