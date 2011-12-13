Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1LMO0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 09:26:36 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61018 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754590Ab1LMO0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 09:26:34 -0500
Date: Tue, 13 Dec 2011 15:26:31 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: drivers/media/video/s5p-fimc/fimc-capture.c: boolean and / or
 confusion
In-reply-to: <1323734123.3837.2.camel@joe2Laptop>
To: Joe Perches <joe@perches.com>
Cc: roel <roel.kluin@gmail.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto <linux-crypto@vger.kernel.org>
Message-id: <4EE76097.4020303@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23)
 Gecko/20110921 Thunderbird/3.1.15
References: <4EE688FC.8090606@gmail.com> <1323733493.1812.10.camel@joe2Laptop>
 <1323734123.3837.2.camel@joe2Laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 12:55 AM, Joe Perches wrote:
> On Tue, 2011-12-13 at 00:06 +0100, roel wrote:
>> The test not [val1] or not [val2] always evaluates to true
> 
> Hello
> 
> Looking at drivers with:
> 
> $ grep -rP --include=*.[ch] "(\b[\w\[\]\>\._\-]+)\s*\!\=\s*[\w\[\]\>\._\-]+\s*\|\|\s*\1\s*\!\=" drivers
> 
> drivers/media/video/s5p-fimc/fimc-capture.c:		if (mf->width != tfmt->width || mf->width != tfmt->width) {
> drivers/media/video/s5p-fimc/fimc-capture.c:			if (mf->width != tfmt->width || mf->width != tfmt->width)
> 
> Most likely these tests should be:
> 	if (mf->height != tfmt->height || mf->width != tfmt->width)

Indeed. I'll prepare a patch fixing this.

-- 
Thank you,
Sylwester
