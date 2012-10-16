Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2JPSEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:04:46 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58716 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab2JPSEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:04:45 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:2602:baac:6fff:fe8c:a1a5]
In-Reply-To: <1350371967-8914-1-git-send-email-josh.wu@atmel.com>
References: <1350371967-8914-1-git-send-email-josh.wu@atmel.com>
Date: Tue, 16 Oct 2012 11:04:44 -0700
Message-ID: <CACiLriQ1fTbGs7eCK5eeF=99um=EQaj-vefjEnvDS0bwWa5m=w@mail.gmail.com>
Subject: Re: [PATCH] avr32: fix build error in atstk1006_defconfig
From: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <havard@skinnemoen.net>
To: Josh Wu <josh.wu@atmel.com>
Cc: linux-kernel@vger.kernel.org, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        fengguang.wu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 12:19 AM, Josh Wu <josh.wu@atmel.com> wrote:
> fixed the following compile error when use avr32 atstk1006_defconfig:
>   drivers/mtd/nand/atmel_nand.c: In function 'pmecc_err_location':
>   drivers/mtd/nand/atmel_nand.c:639: error: implicit declaration of function 'writel_relaxed'
>
> which was introduced by commit 1c7b874d33b463 ("mtd: at91: atmel_nand: add Programmable Multibit ECC controller support").
> The PMECC for nand flash code uses writel_relaxed(). But in avr32, there is no macro "writel_relaxed" defined. This patch add writex_relaxed macro definitions.
>
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Acked-by: Havard Skinnemoen <havard@skinnemoen.net>

I think it's OK to just forward to write[bwl] -- the relaxed variants
merely provide fewer ordering guarantees than the non-relaxed
variants. The worst that could happen is a small performance hit (and
on AVR32, even that is highly unlikely).

Havard
