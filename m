Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0HSLJI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 07:09:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56178 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0HSLJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 07:09:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Date: Thu, 19 Aug 2010 13:09:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
References: <4C61EE55.5030506@codeaurora.org> <201008181428.45029.arnd@arndb.de> <4C6C3910.80800@codeaurora.org>
In-Reply-To: <4C6C3910.80800@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191309.15425.arnd@arndb.de>
X-Provags-ID: V02:K0:Tdc3y89/Hd7xSDGuivrR86wWzbOX+fb1ZG+gNrdmhh+
 dk0QtX4a/KNgM+a3v6SRSJdBr1dyT7o7Lu2uBAyt6bB8D2Qf43
 Vi8QIt0rYcocaSd6CvG0k5H1/7ATLbOdt4FKwQy9WY9NOpbqeA
 2DB4q75n0DcQ6sGl6ZYtrSNRHuBzUIbvvlhYNtNwn/TlnCZJeT
 HmZGL+lZjzGC1i7LdXMEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 August 2010, Stephen Boyd wrote:
> So the only sticking point now is that x86, parisc, and arm use warnings 
> and errors but s390 only uses warnings. I guess I'll reword it to be:
> 
>         Enabling this option turns a certain set of sanity checks for
>         user copy operations into compile time warnings/errors.
> 
>         The copy_from_user() etc checks are there to help test if there
>         are sufficient security checks on the length argument of the
>         copy operation, by having gcc prove that the argument is
>         within bounds.
> 
>         If unsure, or if you run an older (pre 4.4) gcc where this
>         option is a no-op, say N.
> 
> or I'll add a patch to make s390 trigger an error when this is enabled?

(Taking Martin and Heiko on Cc for s390)

I'd strongly suggest making the behavior the same for everyone. It should
be fairly easy to make sure none of these warnings ever triggers
on s390, because most of the Linux device driver code does not get build
there anyway.

I'd also drop the part about old compilers and just say
"If unsure, say N".

	Arnd
