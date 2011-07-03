Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1GCLms (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 07:42:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35252 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1GCLmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 07:42:45 -0400
Date: Sun, 3 Jul 2011 15:42:39 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110703114239.GA4074@albatros>
References: <20110626194618.GA21740@elte.hu>
 <20110626202518.GA4915@albatros>
 <20110626220126.GA24004@elte.hu>
 <20110627083633.GA5846@albatros>
 <20110627104058.45e93c41@pyx>
 <20110627183829.GA16033@albatros>
 <BANLkTikyzxXgfFuwBRdDLvrRN4+fExMwWA@mail.gmail.com>
 <20110701143757.GA22567@albatros>
 <20110701154947.133c30f5@lxorguk.ukuu.org.uk>
 <20110703100131.GA2472@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110703100131.GA2472@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 14:01 +0400, Vasiliy Kulikov wrote:
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> index fc2cdb6..b2a659b 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -38,7 +38,7 @@ static unsigned int dbg_level;
>  
>  static char version[] =
>  	DRV_MODULE_DESC " " DRV_MODULE_NAME
> -	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
> +	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")";
>  
>  MODULE_AUTHOR("Chelsio Communications, Inc.");
>  MODULE_DESCRIPTION(DRV_MODULE_DESC);
> @@ -1402,7 +1402,7 @@ static int __init cxgb3i_init_module(void)
>  {
>  	int rc;
>  
> -	printk(KERN_INFO "%s", version);
> +	printk(KERN_INFO "%s\b", version);

Surely this and init/main.c should have \n, sorry.

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
