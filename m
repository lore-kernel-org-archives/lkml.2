Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab0KYRUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:20:38 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:28894 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593Ab0KYRUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:20:37 -0500
Date: Thu, 25 Nov 2010 12:20:31 -0500
Subject: Re: [RFC/PATCH v6 02/12] media: Media device
Message-ID: <1q7hf5w7lvslx3nba6ooh9j2.1290705631030@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Clemens Ladisch <clemens@ladisch.de>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com,
        broonie@opensource.wolfsonmicro.com, lennart@poettering.net
Content-Type: text/plain; charset=utf-8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-25_09:2010-11-25,2010-11-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=8
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1011250094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAPHKuuM020162

The signedness of char is ambiguous for 8 bit data, which is why an API would normally use u8 (or s8, I guess).

Since this is known to be character data, I would think char would be fine.  I am assuming C compilers would never assume multibyte "char"s.

Regards,
Andy

Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

>Hi Clemens,
>
>Thanks for the review.
>
>On Thursday 25 November 2010 10:33:02 Clemens Ladisch wrote:
>> Laurent Pinchart wrote:
>> > +struct media_device {
>> > ...
>> > +	u8 model[32];
>> > +	u8 serial[40];
>> > +	u8 bus_info[32];
>> 
>> All drivers and userspace applications have to treat this as char[], so
>> why u8[]?
>
>Good question. I've copied the V4L2 practice of using u8 (or __u8) for fixed-
>length strings in structures. I can't think of any reason for that.
>
>I will replace u8 with char unless someone comes up with a good reason to keep 
>u8.
>
>-- 
>Regards,
>
>Laurent Pinchart
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
