Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab1EWUzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:55:45 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:35927 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1EWUzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:55:43 -0400
Subject: Re: [PATCH -next] target: fix tfc_io.c printk format warning
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20110523113555.e37bc856.randy.dunlap@oracle.com>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
	 <20110523113555.e37bc856.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Mon, 23 May 2011 13:47:24 -0700
Message-Id: <1306183644.29724.55.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 11:35 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix printk format warning:
> 
> drivers/target/tcm_fc/tfc_io.c:209: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---

Hey Randy,

Kiran (CC'ed) was going to include this along with a bugfix patch for
scsi-misc, but it's probably easier to just change this in linux-next
now..

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

>  drivers/target/tcm_fc/tfc_io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> and please put an entry in the MAINTAINERS file for drivers/target/
> 

<nod>, sending out that patch shortly.

Thanks,

--nab

> 
> --- linux-next-20110523.orig/drivers/target/tcm_fc/tfc_io.c
> +++ linux-next-20110523/drivers/target/tcm_fc/tfc_io.c
> @@ -203,7 +203,7 @@ int ft_queue_data_in(struct se_cmd *se_c
>  			/* XXX For now, initiator will retry */
>  			if (printk_ratelimit())
>  				printk(KERN_ERR "%s: Failed to send frame %p, "
> -						"xid <0x%x>, remaining <0x%x>, "
> +						"xid <0x%x>, remaining <0x%zx>, "
>  						"lso_max <0x%x>\n",
>  						__func__, fp, ep->xid,
>  						remaining, lport->lso_max);

