Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab1FPSgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 14:36:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47572 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab1FPSgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 14:36:19 -0400
Date: Thu, 16 Jun 2011 11:35:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH -next] target: fix tfc_io.c printk format warning
Message-Id: <20110616113557.0e0b8abe.randy.dunlap@oracle.com>
In-Reply-To: <1306183644.29724.55.camel@haakon2.linux-iscsi.org>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
	<20110523113555.e37bc856.randy.dunlap@oracle.com>
	<1306183644.29724.55.camel@haakon2.linux-iscsi.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4DFA4D1B.0077:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 13:47:24 -0700 Nicholas A. Bellinger wrote:

> On Mon, 2011-05-23 at 11:35 -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Fix printk format warning:
> > 
> > drivers/target/tcm_fc/tfc_io.c:209: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'size_t'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> 
> Hey Randy,
> 
> Kiran (CC'ed) was going to include this along with a bugfix patch for
> scsi-misc, but it's probably easier to just change this in linux-next
> now..

Hey Nick,

Is there some way to have this patch merged for linux-next and mainline?

Thanks.

> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> 
> >  drivers/target/tcm_fc/tfc_io.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > and please put an entry in the MAINTAINERS file for drivers/target/
> > 
> 
> <nod>, sending out that patch shortly.
> 
> Thanks,
> 
> --nab
> 
> > 
> > --- linux-next-20110523.orig/drivers/target/tcm_fc/tfc_io.c
> > +++ linux-next-20110523/drivers/target/tcm_fc/tfc_io.c
> > @@ -203,7 +203,7 @@ int ft_queue_data_in(struct se_cmd *se_c
> >  			/* XXX For now, initiator will retry */
> >  			if (printk_ratelimit())
> >  				printk(KERN_ERR "%s: Failed to send frame %p, "
> > -						"xid <0x%x>, remaining <0x%x>, "
> > +						"xid <0x%x>, remaining <0x%zx>, "
> >  						"lso_max <0x%x>\n",
> >  						__func__, fp, ep->xid,
> >  						remaining, lport->lso_max);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
