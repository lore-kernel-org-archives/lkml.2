Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab1I1BI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 21:08:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61309 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1I1BIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 21:08:55 -0400
MIME-Version: 1.0
In-Reply-To: <1317140310.16786.2.camel@Joe-Laptop>
References: <1317138382-1966-1-git-send-email-linkinjeon@gmail.com>
	<1317140310.16786.2.camel@Joe-Laptop>
Date: Wed, 28 Sep 2011 10:08:54 +0900
Message-ID: <CAKYAXd9zz8398+Mt4yi_etsKr40vHJ6mxb5psd6ix1Ou_dHPOQ@mail.gmail.com>
Subject: Re: [PATCH] udf: enable error print in udf_read_tagged().
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/28 Joe Perches <joe@perches.com>:
> On Wed, 2011-09-28 at 00:46 +0900, Namjae Jeon wrote:
>> While reading metadata, if a problem occurs, Print out only one of the five case.(It also does not show a checksum properly.)
> []
>> diff --git a/fs/udf/misc.c b/fs/udf/misc.c
> []
>> @@ -211,7 +212,7 @@ struct buffer_head *udf_read_tagged(struct super_block *sb, uint32_t block,
>>
>>       bh = udf_tread(sb, block);
>>       if (!bh) {
>> -             udf_debug("block=%d, location=%d: read failed\n",
>> +             printk(KERN_ERR "block=%d, location=%d: read failed\n",
>
> The other printk in this module uses a "udf: " prefix.
>
> I suggest that
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> is added before any include and these
> conversions use pr_err() instead.
It is good suggestion. I will try to make patch v2 included your suggestion.
Thanks for your review.
>
>
>
