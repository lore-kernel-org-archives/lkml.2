Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab1AFGlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 01:41:07 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59415 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab1AFGlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 01:41:05 -0500
Date: Thu, 6 Jan 2011 15:39:07 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: linux-geode@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCH] gx1fb: Fix section mismatch derived from gx1fb_driver variable
Message-ID: <20110106063906.GB15340@linux-sh.org>
References: <1294018289-3911-1-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294018289-3911-1-git-send-email-sedat.dilek@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 02:31:29AM +0100, Sedat Dilek wrote:
> diff --git a/drivers/video/geode/gx1fb_core.c b/drivers/video/geode/gx1fb_core.c
> index c6b554f..9fdb115 100644
> --- a/drivers/video/geode/gx1fb_core.c
> +++ b/drivers/video/geode/gx1fb_core.c
> @@ -437,7 +437,7 @@ static struct pci_device_id gx1fb_id_table[] = {
>  
>  MODULE_DEVICE_TABLE(pci, gx1fb_id_table);
>  
> -static struct pci_driver gx1fb_driver = {
> +static struct pci_driver gx1fb_driver __refdata = {
>  	.name		= "gx1fb",
>  	.id_table	= gx1fb_id_table,
>  	.probe		= gx1fb_probe,

The problem seems to be because gx1fb_probe is annotated __init. In the
PCI case you want it to be __devinit, and you're also going to want to
annotate the remove function as __devexit and wrap it up with a
__devexit_p().
