Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab1E1OYb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 10:24:31 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43874 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1E1OYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 10:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QRaOIZLI3RfV2X869GB3O6+bN0Vvwio5LfSzhkp1U4SeAzvoMlNz3sP0UoW7m4eIZI
         nJZhw38QmvvDaQCdKk6WFfG8o4OE409PdZrcyWDCgvksg+XU4/KVR/XocZFNzSDd+JPq
         hSAeJ6+X5pzyAJ4TIfvCY2jVtx5jIrye9ISzA=
Message-ID: <4DE10436.4070603@gmail.com>
Date: Sat, 28 May 2011 16:18:30 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stevie Trujillo <stevie.trujillo@gmail.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH] ramoops: use module parameters instead of platform data
 if not available
References: <4DE0B9D8.3020405@gmail.com> <201105281205.00421.stevie.trujillo@gmail.com>
In-Reply-To: <201105281205.00421.stevie.trujillo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/05/2011 12:05, Stevie Trujillo ha scritto:
> On Saturday 28 May 2011 11:01:12 you wrote:
>> From: Marco Stornelli<marco.stornelli@gmail.com>
>>
>> Use generic module parameters instead of platform data, if platform
>> data are not available. This limitation has been introduced with
>> commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0.
>>
>> Signed-off-by: Marco Stornelli<marco.stornelli@gmail.com>
>> CC: Kyungmin Park<kyungmin.park@samsung.com>
>> Reported-by: Stevie Trujillo<stevie.trujillo@gmail.com>
>
> Nice work, I think this will fix my problems :) I have some comments - not
> sure how many of them are sane.
>
> I think the indent is wrong (mixed tabs + spaces) in ramoops_init. Tried to
> fix it, but my email client just made it worse :p

Oops, my fault, I'll resend the patch.

>
> With this patch, ramoops_platform_data takes precedence over module
> parameters. Should it maybe be the other way?
>

I don't like the "user overwrite kernel configuration" pattern :) At the 
end, for archs with a device tree source it's possible to change the 
value there.

> I think you can just statically allocate ramoops_platform_data, since it's
> only 2x(unsigned long)? You will use one more long in .data, but less in
> .text?

If some other field it's added to the struct, we already use the right 
policy.

>
> Not related to the patch: Should the printks end with "\n"? If i do
> printk(KERN_ERR "a"); printk(KERN_ERR "b"); I get two lines, but with
> printk(KERN_ERR "a"); printk("b"); they end up on the same line. So if another
> driver did printk without KERN_ after ramoops, they would end up on same line?
>

I'll add the \n with a separate patch.

Marco
