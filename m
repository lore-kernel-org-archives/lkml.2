Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285Ab0HTX7P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 19:59:15 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:22878 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750970Ab0HTX7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 19:59:12 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: DPkEFjQVM1lwHlycQQxxg4wBh3jUqsQFHPolel65.9ZBFBa
 vYtBXSvj8JvpENYYw_MMpdE.K9m9MV2jjLR_jpXi6pm1cctN7OU0SrNNvmAp
 hN56MaetI3CjN5rPRgcZM40d52o2mjbdST6fJUJ6H62aNFuvTGRG7ohd8qgO
 6u2gTStd7CnsZvrEl9AFQakTB0YWFtDIbwCOurzpGmIwfN866OZ_wsomEzLj
 Ic6.6sC3YGI9IVueFtrIqkqYC90_wq.Z0w1g84Z5Y8e72EdyM9OX1D45LjCJ
 bfCbc3njw8vsFd2jBOefkjSknO6rrAa6Mf.rNOk07njapVxR5gOpLkXRU86I
 S8Wnpz9ZrhDbrFkYGLw--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, hare@suse.de
In-Reply-To: <4C6EF67E.2060908@cs.wisc.edu>
References: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
	 <20100820163058P.fujita.tomonori@lab.ntt.co.jp>
	 <4C6EF67E.2060908@cs.wisc.edu>
Content-Type: text/plain
Date: Fri, 20 Aug 2010 16:55:28 -0700
Message-Id: <1282348528.30453.450.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 16:41 -0500, Mike Christie wrote:
> On 08/20/2010 02:32 AM, FUJITA Tomonori wrote:
> > On Thu, 19 Aug 2010 15:45:47 -0700
> > "Nicholas A. Bellinger"<nab@linux-iscsi.org>  wrote:
> >
> >> So, assuming that the conversion of all struct iscsi_init_* and struct
> >> iscsi_target* to use include/scsi/iscsi_proto.h defs just involves
> >> checking structure size and renaming the member use in
> >> drivers/target/lio-target, would it be acceptable to do something like:
> >>
> >> /* iSCSI PDU Header */
> >> struct iscsi_cmd {
> >>          uint8_t opcode;
> >>          uint8_t flags;
> >>          __be16 rsvd2;
> >>          uint8_t hlength;
> >>          uint8_t dlength[3];
> >>          uint8_t lun[8];
> >>          itt_t    itt;   /* Initiator Task Tag */
> >>          __be32 data_length;
> >>          __be32 cmdsn;
> >>          __be32 exp_statsn;
> >>          uint8_t cdb[ISCSI_CDB_SIZE];    /* SCSI Command Block */
> >>          /* Additional Data (Command Dependent) */
> >> #ifdef ISCSI_TARGET_MODE
> >>          __be32 header_digest;
> >> #endif
> >> };
> >
> > It's up to Mike but it looks hacky to me. struct iscsi_pdu is defined
> > in the exact way as the spec does.
> >
> > I don't think that iscsi_proto.h conversion is a must for the mainline
> > inclusion. I prefer to let it alone for now.
> 
> For the iscsi target, I think it is. For iscsi initiator drivers like 
> bnx2i and be2iscsi we have made them convert from their headers to 
> common linux ones including switching from driver specific defs to 
> iscsi_proto.h.

This is kinda what I figured myself..  So in that case, I will go ahead
and plan on using the initial target mode stubs above to get up and
running, and start doing this sometime after the next (seperate) posting
of TCM_Core + TCM_Loop for Tomo-san's review. 

> 
> For the merging of any target core stuff though, I do not think it is 
> critical. The core target stuff does not need to be merged with a 
> software iscsi target. They can do in at different times.

I think in order to merge the software iSCSI target fabric bits for
v2.6.37, it would sense to do it initially with something similar to
these stubs.  From there I can have a more time to make necessary
modifications to LIO-Target and plan removing the header_digest target
stubs from iscsi_proto.h in for the .38 timeframe.

But really, since you so kindly volunteered to review the
drivers/target/lio-target code to start with, this decision is most
certainly yours to me made as the LIO-Target conversion to iscsi_proto.h
starts rolling..  8-)

Thanks for your comments Mike!

--nab

