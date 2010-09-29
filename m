Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab0I2JKS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 05:10:18 -0400
Received: from smtp102.sbc.mail.ac4.yahoo.com ([76.13.13.241]:32046 "HELO
	smtp102.sbc.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753941Ab0I2JKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 05:10:15 -0400
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: 3PL2MPYVM1n9mA.j0_hyEp9pqGl5p69cOSu8tdXKbCizvZ9
 IY7E.PGKh0KC.T51uLcxvGiztWUm4zi8zO0ercRFFNL.ZTPcT6eP7iZlzMxC
 jscxRi5BThE7hmetoxgb6Y3xPFI4w3acEdOffR7NALZVc7CwcAZDp58Snnvr
 natSZDhSDH.qdSQ8DwKRC73vFaRvdKYmFMUNrK9Xml8zDug2UeJzX0Y5vq_u
 my1abzBDWq1RQvEyBlPz8WMZYyzGGCuWOdVJ1XlGeU3n7aPNEjHw5ZTr0_JG
 im3FguMeYfAvX_51Tdg3M1hXMujjHm6lYqlKafQveSGOd7.41tNZTEl0LS7p
 uxPuOAGkARM8X4HnFow--
X-Yahoo-Newman-Property: ymail-3
Subject: Re: [PATCH 1/3] tcm: Add Thin Provisioning / UNMAP emulation and
	Block Limits VPD page
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        James Bottomley <James.Bottomley@suse.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Richard Sharpe <realrichardsharpe@gmail.com>
In-Reply-To: <yq1sk0taeal.fsf@sermon.lab.mkp.net>
References: <1285627889-6450-1-git-send-email-nab@linux-iscsi.org>
	 <yq1sk0taeal.fsf@sermon.lab.mkp.net>
Content-Type: text/plain
Date: Wed, 29 Sep 2010 02:05:56 -0700
Message-Id: <1285751156.18417.57.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-28 at 14:55 -0400, Martin K. Petersen wrote:
> >>>>> "nab" == Nicholas A Bellinger <nab@linux-iscsi.org> writes:
> 
> nab> This patch also adds the Block Limits VPD (0xb0) page
> 
> You should add the Thin Provisioning VPD page as well and set TPU and/or
> TPWS.
> 

Greetings mkp,

So I was looking at adding this VPD page orginally to set TPU=1 w/ DP=0
(because I don't believe there is currently way to get build the
PROVISIONING GROUP DESCRIPTORs from Block Discard knowledge), but I
ended getting a bit confused by the THRESHOLD EXPONENT, and what value
this should returned for the TCM/IBLOCK and TCM/FILEIO backstores when
blk_queue_discard()==1 is enabled.

Since this is currently not implemented in scsi_debug.c or used in any
way by sd.c AFAICT, do you have any additional information on how this
should be determined together with the UNMAP -> blk_issue_discard()
emulation bits..?

Thanks!

--nab

