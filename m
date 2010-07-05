Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0GERMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 13:12:24 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39740 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752035Ab0GERMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 13:12:22 -0400
Subject: Re: [PATCH 02/35] ivtv: use kthread_worker instead of workqueue
From: Andy Walls <awalls@md.metrocast.net>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
       ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
In-Reply-To: <1277759063-24607-3-git-send-email-tj@kernel.org>
References: <1277759063-24607-1-git-send-email-tj@kernel.org>
	 <1277759063-24607-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Jul 2010 13:11:00 -0400
Message-ID: <1278349860.2229.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=1.12.8161:2.4.5,1.2.40,4.0.166
 definitions=2010-07-05_04:2010-02-06,2010-07-05,2010-07-05 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1007050082
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-28 at 23:03 +0200, Tejun Heo wrote:
> Upcoming workqueue updates will no longer guarantee fixed workqueue to
> worker kthread association, so giving RT priority to the irq worker
> won't work.  Use kthread_worker which guarantees specific kthread
> association instead.  This also makes setting the priority cleaner.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andy Walls <awalls@md.metrocast.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: ivtv-devel@ivtvdriver.org
> Cc: linux-media@vger.kernel.org


Assuming the new kthread_worker implementation is OK, this change for
ivtv looks good.

Reviewed-by: Andy Walls <awalls@md.metrocast.net>
Acked-by: Andy Walls <awalls@md.metrocast.net>

Regards,
Andy

>  drivers/media/video/ivtv/ivtv-driver.c |   26 ++++++++++++++++----------
>  drivers/media/video/ivtv/ivtv-driver.h |    8 ++++----
>  drivers/media/video/ivtv/ivtv-irq.c    |   15 +++------------
>  drivers/media/video/ivtv/ivtv-irq.h    |    2 +-
>  4 files changed, 24 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
> index 1b79475..49e0b1c 100644
> --- a/drivers/media/video/ivtv/ivtv-driver.c
> +++ b/drivers/media/video/ivtv/ivtv-driver.c


