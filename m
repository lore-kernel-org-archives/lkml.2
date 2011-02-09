Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab1BIXqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 18:46:42 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56586 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab1BIXql convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:46:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NshZuXEO4TeahGJsZlJSxm3EJhAmqfMdDaKd9xag5Eq2FIGtqXUJJuO3HV3f1ly7KO
         MJID+fCI73v5fTL9Yq8T1rH6ryDXD+u5HcUIRYZLvX4RzT117M4HErylr4svKjZikFlM
         aBAnGiJ0nGt9RVF6e9CsxheZzrV7G/yxgRpV4=
MIME-Version: 1.0
In-Reply-To: <4D52D091.1000504@vflare.org>
References: <AANLkTi=CEXiOdqPZgQZmQwatHqZ_nsnmnVhwpdt=7q3f@mail.gmail.com>
	<5c529b08-cf36-43c7-b368-f3f602faf358@default>
	<4D52D091.1000504@vflare.org>
Date: Thu, 10 Feb 2011 08:46:40 +0900
Message-ID: <AANLkTimuivx6kroZ0v0J8GZQmBngHHDTfztGamnp2UJk@mail.gmail.com>
Subject: Re: [PATCH V2 2/3] drivers/staging: zcache: host services and PAM services
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, gregkh@suse.de,
        Chris Mason <chris.mason@oracle.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, matthew@wil.cx,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jeremy@goop.org,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        riel@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        kosaki.motohiro@jp.fujitsu.com, sfr@canb.auug.org.au,
        wfg@mail.ustc.edu.cn, tytso@mit.edu, viro@zeniv.linux.org.uk,
        hughd@google.com, hannes@cmpxchg.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nitin,

Sorry for late response.

On Thu, Feb 10, 2011 at 2:36 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> On 02/09/2011 11:39 AM, Dan Magenheimer wrote:
>>
>>
>>> From: Minchan Kim [mailto:minchan.kim@gmail.com]
>>
>>> As I read your comment, I can't find the benefit of zram compared to
>>> frontswap.
>>
>> Well, I am biased, but I agree that frontswap is a better technical
>> solution than zram. ;-)  But "dynamic-ity" is very important to
>> me and may be less important to others.
>>
>
>
> I agree that frontswap is better than zram when considering swap as the use
> case - no bio overhead, dynamic resizing. However, zram being a *generic*
> block-device has some unique cases too like hosting files on /tmp, various
> caches under /var or any place where a compressed in-memory block device can
> help.

Yes. I mentioned that benefit but I am not sure the reason is enough.
What I had in mind long time ago is that zram's functionality into brd.
So someone who want to compress contents could use it with some mount
option to enable compression.
By such way, many ramdisk user can turn it on easily.
If many user begin using the brd, we can see many report about
performance then solve brd performance s as well as zcache world-wide
usage.

Hmm,  the idea is too late?

>
> So, frontswap and zram have overlapping use case of swap but are not the
> same.

If we can insert zram's functionality into brd, maybe there is no
reason to coexist.


>
> Thanks,
> Nitin
>



-- 
Kind regards,
Minchan Kim
