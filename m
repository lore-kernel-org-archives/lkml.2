Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab2DULSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 07:18:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:50124 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab2DULSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 07:18:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 12/17] ARM clps711x: Simple optimise debug_macro by removing one NOP
Date: Sat, 21 Apr 2012 11:18:23 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Alexander Shiyan <shc_work@mail.ru>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <1334999490-27177-1-git-send-email-shc_work@mail.ru> <1334999490-27177-13-git-send-email-shc_work@mail.ru>
In-Reply-To: <1334999490-27177-13-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201204211118.23857.arnd@arndb.de>
X-Provags-ID: V02:K0:TpvpaiMFg2J488Nuit3jG71AHWpjhkd77xMfetVSfV7
 xdb8mhzblyENoOPebuH9sCY5e7+qngkl15OnerZBE0ttnuCNqP
 i19dpa0/gU+HyhoZFkbqwNxuCgcE/qA4BfNuLhqCjTo2+QTtNX
 WFoKFJCvL4xQSKgaN6xIxw2MbPkf2+sQfnbiEBJUsbr7vq9Z1i
 be6Q8FgXxpceIvLWQj0hyVh8ZX1eE7J344gvvw9EWyIT/YFrm+
 oiC0AMbkrV4dlunB/pV/SuMTgCnqB5JFppWd+G+vbrTa5goTUi
 wk8exHOHUpwiPpgDbzKQ+45XC2RIOmUydE4NBxMidg1hid+vXS
 mJR6hdVNHGYDEsNSTo/4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 April 2012, Alexander Shiyan wrote:
> 
>                 .macro  addruart, rp, rv, tmp
> -#ifndef CONFIG_DEBUG_CLPS711X_UART2
> -               mov     \rp, #0x0000    @ UART1
> -#else
> -               mov     \rp, #0x1000    @ UART2
> +#ifdef CONFIG_DEBUG_CLPS711X_UART2
> +               mov     \rp, #0x1000    @ Add offset for UART2 base reg
>  #endif
>                 orr     \rv, \rp, #CLPS711X_VIRT_BASE
>                 orr     \rp, \rp, #CLPS711X_PHYS_BASE

This looks wrong at first sight. Is rp guaranteed to be zero when calling
the macro? Am I misreading this? Sorry my ARM assembly skill is still horrible.

	Arnd
