Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab0LSQlt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 11:41:49 -0500
Received: from box.houkouonchi.jp ([208.97.140.21]:36957 "EHLO
	box.houkouonchi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420Ab0LSQls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 11:41:48 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2010 11:41:48 EST
Message-ID: <4D0E3435.30104@van-ness.com>
Date: Sun, 19 Dec 2010 08:35:01 -0800
From: Sandon Van Ness <sandon@van-ness.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Thunderbird/3.0
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>
CC: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Subject: Re: Is EXT4 the right FS for > 16TB?
References: <alpine.DEB.2.00.1012190649060.5393@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.00.1012190649060.5393@p34.internal.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was it me (houkouonchi) on hard forum? I asked if > 16 TiB support was
considered stable on here a while back:

Is >16TB support considered stable?

This was 6 months ago so maybe things have changed. The thread:

http://kerneltrap.org/mailarchive/linux-ext4/2010/5/28/6884603/thread

Luckily JFS fixed there userland utilities bug of not being able to
handle > 32TiB very shortly after this and I ended up going that route
and I have yet to have any data loss or problems on my JFS volume:

root@dekabutsu: 08:32 AM :~# df -H /data
Filesystem             Size   Used  Avail Use% Mounted on
/dev/sdd1               36T    22T    15T  61% /data
root@dekabutsu: 08:32 AM :~#      

At work with our hundreds/thousands of servers we will likely be going
ext4 as we wont be using it on >16 TiB. I think its a huge improvement
over ext3 but for my use JFS ended up being a better fit. I
refuse/refused to go XFS.

On 12/19/2010 03:52 AM, Justin Piszcz wrote:
> Hi,
>
> I've read a lot of posts regarding people who setup RAID volumes of
> and up to around 16TB and EXT4 is typically used.
>
> However, in various forums, people still ask what is the correct
> filesystem for > 16TB?  I did read one post somewhere that stated the
> ext4 developers did not recommend using ext4 for very large volumes,
> is this still true?
>
> I am looking at creating a 43TB volume possibly in the near future and
> I have used XFS in the past, which works well and would probably not
> have any problem with it; however, I have bitten quite a number of
> times by XFS bugs in the past several years, so I was curious, how
> does EXT4 perform on larger volumes, e.g., 20TB?
>
> Are there any caveats / problems?
>
> Justin.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

