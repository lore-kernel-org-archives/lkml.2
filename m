Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab1CVSXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:23:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:53109 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab1CVSXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:23:46 -0400
Message-ID: <4D88E927.4010303@infradead.org>
Date: Tue, 22 Mar 2011 15:23:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: manjunatha_halli@ti.com, hverkuil@xs4all.nl, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH -next] drivers:media:radio: wl128x: fix printk format
 and text
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>	<1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>	<1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>	<1294745487-29138-4-git-send-email-manjunatha_halli@ti.com> <20110318091854.b234ad3e.randy.dunlap@oracle.com>
In-Reply-To: <20110318091854.b234ad3e.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-03-2011 13:18, Randy Dunlap escreveu:
> What happened to this driver in linux-next of 2011.0318?
> It's in linux-next of 2011.0317.
> 
> Here's a patch that was prepared against linux-next of 2011.0317.
> 
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix text spacing and grammar.
> Fix printk format warning:
> 
> drivers/media/radio/wl128x/fmdrv_common.c:274: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/media/radio/wl128x/fmdrv_common.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20110317.orig/drivers/media/radio/wl128x/fmdrv_common.c
> +++ linux-next-20110317/drivers/media/radio/wl128x/fmdrv_common.c
> @@ -271,8 +271,8 @@ static void recv_tasklet(unsigned long a
>  	/* Process all packets in the RX queue */
>  	while ((skb = skb_dequeue(&fmdev->rx_q))) {
>  		if (skb->len < sizeof(struct fm_event_msg_hdr)) {
> -			fmerr("skb(%p) has only %d bytes"
> -				"atleast need %d bytes to decode\n", skb,
> +			fmerr("skb(%p) has only %d bytes; "
> +				"need at least %zd bytes to decode\n", skb,
>  				skb->len, sizeof(struct fm_event_msg_hdr));
>  			kfree_skb(skb);
>  			continue;

Thanks, but it got superseeded by this one:

commit c6a721201f0ab67dc86709afe7b8f0e549bcdd07
Author:     Hans Verkuil <hverkuil@xs4all.nl>
AuthorDate: Sun Mar 6 09:30:02 2011 -0300
Commit:     Mauro Carvalho Chehab <mchehab@redhat.com>
CommitDate: Fri Mar 11 14:13:23 2011 -0300

    [media] fmdrv_common.c: fix compiler warning
    
    drivers/media/radio/wl128x/fmdrv_common.c: In function 'recv_tasklet':
    drivers/media/radio/wl128x/fmdrv_common.c:274:4: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'
    
    The result of sizeof() should be printed with %zu.
    
    Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/radio/wl128x/fmdrv_common.c b/drivers/media/radio/wl128x/fmdrv_common.c
index 12f4c65..64454d3 100644
--- a/drivers/media/radio/wl128x/fmdrv_common.c
+++ b/drivers/media/radio/wl128x/fmdrv_common.c
@@ -271,8 +271,8 @@ static void recv_tasklet(unsigned long arg)
 	/* Process all packets in the RX queue */
 	while ((skb = skb_dequeue(&fmdev->rx_q))) {
 		if (skb->len < sizeof(struct fm_event_msg_hdr)) {
-			fmerr("skb(%p) has only %d bytes"
-				"atleast need %d bytes to decode\n", skb,
+			fmerr("skb(%p) has only %d bytes, "
+				"at least need %zu bytes to decode\n", skb,
 				skb->len, sizeof(struct fm_event_msg_hdr));
 			kfree_skb(skb);
 			continue;

Thanks,
Mauro
