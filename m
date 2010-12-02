Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab0LBVJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:09:59 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:9766 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932079Ab0LBVJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:09:58 -0500
Date: Thu, 02 Dec 2010 16:08:55 -0500
Subject: Re: [PATCH] media: rc: ir-lirc-codec: fix potential integer
 overflow
Message-ID: <5riroj2l9iwsfksrf7xjglim.1291324135751@email.android.com>
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@redhat.com>, Dan Carpenter <error27@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=utf-8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-12-02_10:2010-12-02,2010-12-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=8
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1010190000 definitions=main-1012020128
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oB2LAMTP028659

64 bit value / 4 = 62 bit value, right?


Jarod Wilson <jarod@redhat.com> wrote:

>On Thu, Dec 02, 2010 at 07:51:26AM +0300, Dan Carpenter wrote:
>> On Fri, Nov 26, 2010 at 08:06:35PM +0300, Vasiliy Kulikov wrote:
>> >  	count = n / sizeof(int);
>> > -	if (count > LIRCBUF_SIZE || count % 2 == 0)
>> > +	if (count > LIRCBUF_SIZE || count % 2 == 0 || n % sizeof(int) != 0)
>>                                                       ^^^^^^^^^^^^^^^^^^^^
>> 
>> Wait, what?  We just checked this a couple lines before.
>
>Bah. I'd only looked at the diff, which didn't have enough context. I
>thought that looked familiar. Indeed, this part seems to be unnecessary.
>
>> The rest of the patch is right and a clever catch.  It would affect 
>> x86_64 systems and not i386.  This doesn't have security implications
>> does it?  You'd just catch the kmalloc() stack trace for insanely large
>> allocations.
>
>Even on x86_64, it looks to my (relatively untrained) eye like you'd
>actually be fine. n is a size_t (so, 64-bit on x86_64). count is an int
>(so 32-bit on x86_64). We initialize count to some 64-bit value / 4, so
>at most, 16 bits, which always fits just fine in the 32-bit int, no?
>
>-- 
>Jarod Wilson
>jarod@redhat.com
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
