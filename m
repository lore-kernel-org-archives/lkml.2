Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2FAFwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 01:52:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25361 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab2FAFwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 01:52:00 -0400
X-AuditID: cbfee61b-b7faf6d000001f49-7c-4fc8585c1840
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <7155413ec18f57c1151a29992be32b1f.squirrel@www.codeaurora.org>
In-reply-to: <7155413ec18f57c1151a29992be32b1f.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v6 2/3] mmc: core: Support packed write command for eMMC4.5
 device
Date: Fri, 01 Jun 2012 14:51:23 +0900
Message-id: <000201cd3fba$942df840$bc89e8c0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0/YiOWiIpnqc8aTUyBa66Ob9GDEQARwWcw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd2YiBP+Bi0NRhaXd81hszjyv5/R
	gcnj8ya5AMYoLpuU1JzMstQifbsErozFV/8wFXzgqPjz/gRbA+NPti5GTg4JAROJI6eeMkLY
	YhIX7q0HinNxCAlMZ5RYNOsYE4Tzh1Hi1sXV7CBVbAJaEn/fvGEGsUUEJCRm7P3ECmIzC8RI
	zG89wAJiCwl4Sfx9dhgszingLfGrYwOQzcEhLBAhseC0NkiYRUBVYtHLZrDFvAK2EjN2b2SC
	sAUlfky+xwIxUk/i45/bjBC2vMTmNW+ZQcZICKhLPPqrC3GBkcTua5OhLhCR2PfiHeMERqFZ
	SCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHNDPpHcwrmqwOMQo
	wMGoxMO7wu+EvxBrYllxZe4hRgkOZiURXoY3x/2FeFMSK6tSi/Lji0pzUosPMUpzsCiJ8z5Z
	ssNfSCA9sSQ1OzW1ILUIJsvEwSnVwGjp5+7wZYe1s7mJI2vM1YOumRKl4tptLp9qdqy7HWdk
	8kgkyzLqx5nw1YdzapI+/38+6eIZ7WUKkyZ+Phnlc2LXi4XHDPNtivUNLa5f3ctW/DNjhozY
	5K0lfrJ3xF7I3Fn3J6Ezxme3o+vGiTtZ1StY7HulfCoi81TCzTt2ZLqY5NUEPZTwVGIpzkg0
	1GIuKk4EAG8MW5JkAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:
> > @@ -1313,10 +1609,17 @@ static int mmc_blk_issue_rw_rq(struct mmc_queue
> *mq, struct request *rqc)
> >  			 * A block was successfully transferred.
> >  			 */
> >  			mmc_blk_reset_success(md, type);
> > -			spin_lock_irq(&md->lock);
> > -			ret = __blk_end_request(req, 0,
> > +
> > +			if (mq_rq->packed_cmd != MMC_PACKED_NONE) {
> > +				ret = mmc_blk_end_packed_req(mq, mq_rq);
> If a specific request in the packed request consistantly fails, there is
> nothing to stop us from sending the same packed request in an endless
> loop.
There is various error case. This patch reused the existing error handling.
What is that case we need to consider?

Best regards,
Seungwon Jeon

> > +				break;
> 
> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

