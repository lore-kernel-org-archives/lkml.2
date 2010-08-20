Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0HTJSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:18:17 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:40323 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751143Ab0HTJSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:18:16 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 99YEWDAVM1mDvT83lWktkwRlJDlHT.CD.cD2quBB7AcQNjM
 W8WXf4FUQesVT0QgLf2VWNV54H4bJmC3HQCRw2WpeLT88Kx02IH_VtsXqXxV
 sbzLoG9aaX4iPF_wQZSfU_9xUACaXuGZWpY0Q6TSeusSamiy7yutLmmAhb0K
 Axg3xCmlIX1.6IFjqdi8BJOmX75k1mDV6rCdp32pCmPA4jgNYLDKZeYlMIRH
 JMDJnnR0HX9gLXM7LNhCMKuO5HGav9e4Du3.7F_ZOrYNaB5HaNyFTKnNkPF3
 BjrcO7dGCKKTDYQFh0BFfnRChyLAIkiLtTHzvdWfdX35uTPuAd5v8XLfipa5
 dyWN0VuJ7Eg19ckVddg--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: Conversion of LIO-Target to use include/scsi/iscsi_proto.h defs
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@lst.de, James.Bottomley@suse.de,
        hare@suse.de
In-Reply-To: <20100820163058P.fujita.tomonori@lab.ntt.co.jp>
References: <1282257947.30453.296.camel@haakon2.linux-iscsi.org>
	 <20100820163058P.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Date: Fri, 20 Aug 2010 02:14:34 -0700
Message-Id: <1282295674.30453.337.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 16:32 +0900, FUJITA Tomonori wrote:
> On Thu, 19 Aug 2010 15:45:47 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > So, assuming that the conversion of all struct iscsi_init_* and struct
> > iscsi_target* to use include/scsi/iscsi_proto.h defs just involves
> > checking structure size and renaming the member use in
> > drivers/target/lio-target, would it be acceptable to do something like:
> > 
> > /* iSCSI PDU Header */
> > struct iscsi_cmd {
> >         uint8_t opcode;
> >         uint8_t flags;
> >         __be16 rsvd2;
> >         uint8_t hlength;
> >         uint8_t dlength[3];
> >         uint8_t lun[8];
> >         itt_t    itt;   /* Initiator Task Tag */
> >         __be32 data_length;
> >         __be32 cmdsn;
> >         __be32 exp_statsn;
> >         uint8_t cdb[ISCSI_CDB_SIZE];    /* SCSI Command Block */
> >         /* Additional Data (Command Dependent) */
> > #ifdef ISCSI_TARGET_MODE
> >         __be32 header_digest;
> > #endif
> > };
> 
> It's up to Mike but it looks hacky to me. struct iscsi_pdu is defined
> in the exact way as the spec does.
> 
> I don't think that iscsi_proto.h conversion is a must for the mainline
> inclusion. I prefer to let it alone for now.

Hmmmm, Ok..  Then I will defer to mnc's judgement here about what level
of integration of LIO-Target for protocol and PDU defs for what he
currently handles with Open-iSCSI.  Mike, do you have any more thoughts
here..?

I am pretty sure there are more important items to focus on inside from
this particuarly time-consuming and tedious cleanup, but am happy to
start a smaller cleanup of drivers/target/lio-target/iscsi_protocol.h
for starters..

Also, LIO-Target is still using an internal CRC32C implementation, which
needs to be converted to libcrypto and crc32c.ko.  Which also reminds
me, it would be nice to get the slicing by 8 CRC32C support into
libcrypto, and properly support for the Nehalem's CRC32C instruction
capabilities too.  Any takers..?  ;)

Best,

--nab


