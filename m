Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1CUT1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:27:54 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59407 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab1CUT1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:27:52 -0400
References: <1300732426-18958-1-git-send-email-florian@mickler.org>
User-Agent: K-9 Mail for Android
In-Reply-To: <1300732426-18958-1-git-send-email-florian@mickler.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/6] get rid of on-stack dma buffers
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 21 Mar 2011 15:26:43 -0400
To: Florian Mickler <florian@mickler.org>, mchehab@infradead.org
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, js@linuxtv.org,
        tskd2@yahoo.co.jp, liplianin@me.by, g.marco@freenet.de,
        aet@rasterburn.org, pb@linuxtv.org, mkrufky@linuxtv.org,
        nick@nick-andrew.net, max@veneto.com, janne-dvb@grunau.be
Message-ID: <a08d026a-d4c3-4ee5-b01a-d561f755b1ec@email.android.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-21_06:2011-03-16,2011-03-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1103210117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Florian Mickler <florian@mickler.org> wrote:

>Hi all!
>
>These patches get rid of on-stack dma buffers for some of the dvb-usb
>drivers. 
>I do not own the hardware, so these are only compile tested. I would 
>appreciate testing and review.
>They were previously sent to the list, but some error on my side
>prevented (some of?) them from beeing delivered to all parties (the
>lists).
>
>These changes are motivated by 
>https://bugzilla.kernel.org/show_bug.cgi?id=15977 .
>
>The patches which got tested already were submitted to Mauro (and
>lkml/linux-media) yesterday seperately. Those fix this same issue for
>ec168,
>ce6230, au6610 and lmedm04. 
>
>A fix for vp702x has been submitted seperately for review on the list.
>I have
>similiar fixes like the vp702x-fix for dib0700 (overlooked some
>on-stack
>buffers in there in my original submission as well) and gp8psk, but I
>am
>holding them back 'till I got time to recheck those and getting some
>feedback
>on vp702x.
>
>Please review and test.
>
>Regards,
>Flo
>
>Florian Mickler (6):
>  [media] a800: get rid of on-stack dma buffers
>  [media v2] vp7045: get rid of on-stack dma buffers
>  [media] friio: get rid of on-stack dma buffers
>  [media] dw2102: get rid of on-stack dma buffer
>  [media] m920x: get rid of on-stack dma buffers
>  [media] opera1: get rid of on-stack dma buffer
>
> drivers/media/dvb/dvb-usb/a800.c   |   17 ++++++++++---
> drivers/media/dvb/dvb-usb/dw2102.c |   10 ++++++-
> drivers/media/dvb/dvb-usb/friio.c  |   23 ++++++++++++++---
> drivers/media/dvb/dvb-usb/m920x.c  |   33 ++++++++++++++++--------
> drivers/media/dvb/dvb-usb/opera1.c |   31 +++++++++++++++--------
>drivers/media/dvb/dvb-usb/vp7045.c |   47
>++++++++++++++++++++++++++----------
> 6 files changed, 116 insertions(+), 45 deletions(-)
>
>-- 
>1.7.4.1
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Florian,

For all of these, what happens when the USB call times out and you kfree() the buffer?  Can the USB DMA actually complete after this kfree(), possibly corrupting space that has been reallocated off the heap, since the kfree()?

This is the scenario for which I assume allocating off the stack is bad.  

Do these changes simply make corruption less noticable since heap gets corrupted vs stack?

Regards,
Andy
