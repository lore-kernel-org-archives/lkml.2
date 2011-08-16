Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1HPVWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:22:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52177 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039Ab1HPVWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:22:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Frysinger <vapier@gentoo.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH] arch/arm: compute and export NR_syscalls
Date: Tue, 16 Aug 2011 23:21:21 +0200
Message-ID: <1629809.vjtjo6obCs@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <1313529267-4428-1-git-send-email-wad@chromium.org>
References: <1313529267-4428-1-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:WMDrzQx9v02XrMj5do7wXAooDmPtpvkj2KCfHxqo9E0
 pwuQFt6HjgbTE04Y3sRC3ctBCBgpuUXfQB209HLwXRP5afsho8
 hdgBJIvtomlj+HK2lkjOt3bcxg3w65QspM/goYoZxUihDwh8RM
 2BnhhlKvkf+K8mOw0Cr2XkxjMJFmgfe5i39dwAuAXerbFA8Klr
 S7lPV1sVxNHl2KDwe2K7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 August 2011 16:14:26 Will Drewry wrote:
> 
> asm-exports.c is added instead of reusing asm-offsets.c to avoid a
> variety of collisions (VM_EXEC, DMA_*, etc).  It is possible to use the
> same calls.S mechanism but add NR_syscalls to asm-offsets.c.  However,
> at inclusion time for generated/asm-offsets.h, conflicting defines will
> need to be #undef'd if !__ASSEMBLY__ since it appears that the purpose
> of asm-offsets.h is to safely bind C language definitions to assembly
> and not the reverse.
> 
> - Is this approach palatable?
> - Should I resend only when paired with the other ftrace-needed patches?

This seems overly complex, compared to a one-line change adding the symbol
to asm/unistd.h. The only other architecture that uses an approach
like the one you have posted is x86-64, and it's simpler there
because it can easily be done in asm-offsets.c there without the need
to create another helper.

	Arnd
