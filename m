Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1JCN7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:59:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38875 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab1JCN6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:58:55 -0400
MIME-Version: 1.0
In-Reply-To: <1317646666.3866.3.camel@Joe-Laptop>
References: <1317626352-29971-1-git-send-email-linkinjeon@gmail.com>
	<1317646666.3866.3.camel@Joe-Laptop>
Date: Mon, 3 Oct 2011 22:58:54 +0900
Message-ID: <CAKYAXd9HMPQYiab7r5jjKoMyxArrfkoF74zBfwdBndA5PYQO6A@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] udf : enable error print in udf_read_tagged().
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/3 Joe Perches <joe@perches.com>:
> On Mon, 2011-10-03 at 16:19 +0900, Namjae Jeon wrote:
>> And I use pr_fmt instead of printk by joe's suggestion. I try to modify totally it to pr_fmt also.
> []
>> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> []
>> @@ -19,18 +21,15 @@
>>  #undef UDFFS_DEBUG
>>
>>  #ifdef UDFFS_DEBUG
>> -#define udf_debug(f, a...) \
>> -do { \
>> -     printk(KERN_DEBUG "UDF-fs DEBUG %s:%d:%s: ", \
>> -             __FILE__, __LINE__, __func__); \
>> -     printk(f, ##a); \
>> -} while (0)
>> +#define udf_debug(fmt, ...)  \
>> +     pr_debug("DEBUG %s:%d:%s: ", fmt,       \
>> +             __FILE__, __LINE__, __func__, __VA_ARGS__);
>
> This doesn't compile properly if UDFFS_DEBUG is
> #defined.
>
> No comma should be between "DEBUG %s:%d:%s: " and fmt.
Hi. Joe.
oops! it's my mistake.
I  sent v3 patch again.
Would you review one more ?
Thanks.
>
>
>
