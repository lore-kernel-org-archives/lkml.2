Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab2EJGTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:19:48 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:36461 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752843Ab2EJGTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:19:47 -0400
From: =?utf-8?B?U3RldmVuIExpdSAo5YqJ5Lq66LGqKQ==?= 
	<steven.liu@mediatek.com>
To: "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 10 May 2012 14:19:43 +0800
Subject: [PATCH] inet_lro: fix VLAN LRO issue
Thread-Topic: [PATCH] inet_lro: fix VLAN LRO issue
Thread-Index: Ac0uc/iH5Ar6A+4tRsycZTnFutlC0w==
Message-ID: <599E416D1C5C994980C45977191D726906AB2FE9AC@MTKMBS03.mediatek.inc>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-TW, en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4A6KY5x008590

Hi Sir,

From: Steven Liu <steven_liu@mediatek.com>

Current LRO implementation cannot handle VLAN tagged packets correctly.
It uses correct packet length when creating new LRO session, but uses wrong packet length when putting following packets into exist LRO session.

Signed-off-by: Steven Liu <steven_liu@mediatek.com>
---
Linux-3.4-rc3 and below version have such issue
--- net/ipv4/inet_lro.orig      2012-05-08 20:09:44.810366089 +0800
+++ net/ipv4/inet_lro.c 2012-05-08 20:09:33.331679419 +0800
@@ -353,7 +353,7 @@ static int __lro_proc_skb(struct net_lro
        if (lro_desc->tcp_next_seq != ntohl(tcph->seq))
                goto out2;

-       if (lro_tcp_ip_check(iph, tcph, skb->len, lro_desc))
+       if (lro_tcp_ip_check(iph, tcph, skb->len - vlan_hdr_len, lro_desc))
                goto out2;

        lro_add_packet(lro_desc, skb, iph, tcph);


Regards,

Steven

************* Email Confidentiality Notice ********************
The information contained in this e-mail message (including any 
attachments) may be confidential, proprietary, privileged, or otherwise
exempt from disclosure under applicable laws. It is intended to be 
conveyed only to the designated recipient(s). Any use, dissemination, 
distribution, printing, retaining or copying of this e-mail (including its 
attachments) by unintended recipient(s) is strictly prohibited and may 
be unlawful. If you are not an intended recipient of this e-mail, or believe 
that you have received this e-mail in error, please notify the sender 
immediately (by replying to this e-mail), delete any and all copies of 
this e-mail (including any attachments) from your system, and do not
disclose the content of this e-mail to any other person. Thank you!ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
