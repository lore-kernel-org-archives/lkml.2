Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab0LGVQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 16:16:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755165Ab0LGVQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 16:16:34 -0500
Date: Tue, 7 Dec 2010 13:16:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] telephony/ixj: fix compiler warning on ixj_pci_tbl
Message-Id: <20101207131600.b769e3df.akpm@linux-foundation.org>
In-Reply-To: <1291736993-15278-1-git-send-email-namhyung@gmail.com>
References: <1291736993-15278-1-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Dec 2010 00:49:53 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> Annotate ixj_pci_tbl as '__used' to fix following warning:
> 
>   CC      drivers/telephony/ixj.o
> drivers/telephony/ixj.c:287: warning: ___ixj_pci_tbl___ defined but not used
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  drivers/telephony/ixj.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
> index 0d236f4..de92133 100644
> --- a/drivers/telephony/ixj.c
> +++ b/drivers/telephony/ixj.c
> @@ -284,7 +284,7 @@ static int samplerate = 100;
>  
>  module_param(ixjdebug, int, 0);
>  
> -static struct pci_device_id ixj_pci_tbl[] __devinitdata = {
> +static struct pci_device_id ixj_pci_tbl[] __devinitdata __used = {
>  	{ PCI_VENDOR_ID_QUICKNET, PCI_DEVICE_ID_QUICKNET_XJ,
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
>  	{ }

This way, I believe:

--- a/drivers/telephony/ixj.c~a
+++ a/drivers/telephony/ixj.c
@@ -284,12 +284,11 @@ static int samplerate = 100;
 
 module_param(ixjdebug, int, 0);
 
-static struct pci_device_id ixj_pci_tbl[] __devinitdata = {
+static DEFINE_PCI_DEVICE_TABLE(ixj_pci_tbl) = {
 	{ PCI_VENDOR_ID_QUICKNET, PCI_DEVICE_ID_QUICKNET_XJ,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };
-
 MODULE_DEVICE_TABLE(pci, ixj_pci_tbl);
 
 /************************************************************************

It fixes the warning, but I'm not sure how it did that.
