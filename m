Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab1E1KFI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 06:05:08 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40952 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1E1KFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 06:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=lvrDuI9aIGT6+HFA9aaV14lKvTmFXtLx4jdc8MjaAm9njkn2gwZam3pqQGHY8OvHKu
         Rl4lxxxUJBrUlGyIbu4aM/uzcIQaiBQHSieIO4g9KHtYDwekta/4D9EuypytEITL1+PI
         wqrOELmea3iWO4q91PfkQIhyn6Zq52aiaFq2c=
From: Stevie Trujillo <stevie.trujillo@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [PATCH] ramoops: use module parameters instead of platform data if not available
Date: Sat, 28 May 2011 12:05:00 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38.4-ck3; KDE/4.6.3; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        xiyou.wangcong@gmail.com
References: <4DE0B9D8.3020405@gmail.com>
In-Reply-To: <4DE0B9D8.3020405@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105281205.00421.stevie.trujillo@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 May 2011 11:01:12 you wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> Use generic module parameters instead of platform data, if platform
> data are not available. This limitation has been introduced with
> commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> CC: Kyungmin Park <kyungmin.park@samsung.com>
> Reported-by: Stevie Trujillo <stevie.trujillo@gmail.com>

Nice work, I think this will fix my problems :) I have some comments - not 
sure how many of them are sane.

I think the indent is wrong (mixed tabs + spaces) in ramoops_init. Tried to 
fix it, but my email client just made it worse :p

With this patch, ramoops_platform_data takes precedence over module 
parameters. Should it maybe be the other way? 

I think you can just statically allocate ramoops_platform_data, since it's 
only 2x(unsigned long)? You will use one more long in .data, but less in 
.text?

Not related to the patch: Should the printks end with "\n"? If i do 
printk(KERN_ERR "a"); printk(KERN_ERR "b"); I get two lines, but with 
printk(KERN_ERR "a"); printk("b"); they end up on the same line. So if another 
driver did printk without KERN_ after ramoops, they would end up on same line?

--
Stevie Trujillo
