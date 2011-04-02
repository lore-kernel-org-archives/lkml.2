Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1DBVI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 17:08:56 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:56751 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab1DBVIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 17:08:54 -0400
Subject: Re: [patch] [SCSI] tcm_loop: off by one in tcm_loop_make_naa_tpg()
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Dan Carpenter <error27@gmail.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <20110329031804.GB9856@bicker>
References: <20110329031804.GB9856@bicker>
Content-Type: text/plain
Date: Sat, 02 Apr 2011 14:01:33 -0700
Message-Id: <1301778093.2319.435.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 06:18 +0300, Dan Carpenter wrote:
> This is an off by one that could result in memory corruption.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 

Hi Dan,

Apologies for the delayed response on here..

This has been included as commit fb9b35be into lio-core-2.6.git/lio-4.1
@ .39-rc1, and will get this queued to James as a 'for-39' mainline
bugfix item.

Thank you!

--nab

> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index aed4e46..2bb5062 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -1239,7 +1239,7 @@ struct se_portal_group *tcm_loop_make_naa_tpg(
>  	tpgt_str += 5; /* Skip ahead of "tpgt_" */
>  	tpgt = (unsigned short int) simple_strtoul(tpgt_str, &end_ptr, 0);
>  
> -	if (tpgt > TL_TPGS_PER_HBA) {
> +	if (tpgt >= TL_TPGS_PER_HBA) {
>  		printk(KERN_ERR "Passed tpgt: %hu exceeds TL_TPGS_PER_HBA:"
>  				" %u\n", tpgt, TL_TPGS_PER_HBA);
>  		return ERR_PTR(-EINVAL);

