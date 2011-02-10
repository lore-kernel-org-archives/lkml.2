Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab1BJNjB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 08:39:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33249 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab1BJNjA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 08:39:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=C0SYFKfo24uEncvi8vMF1LcmhvuybTMM5VD7+M8blqmIQTzNzS3Ggxr/DhnqYmRUTN
         OVqEWKgREm+5XhWvaYG1vmN0PO7dGk8X10F75hsIXC0VvLgsgiM0oJMzIBVrZg3GWIZc
         1XN22oLkvP3MSTYMJfNVn0233lUhpUot7Ze88=
MIME-Version: 1.0
In-Reply-To: <1297343929.1449.3.camel@leonhard>
References: <1297338408-3590-1-git-send-email-namhyung@gmail.com>
	<AANLkTikEigbPsNMqqkmixYbCfD7Dz12YMcW2+GZbhUQq@mail.gmail.com>
	<1297343929.1449.3.camel@leonhard>
Date: Thu, 10 Feb 2011 22:38:59 +0900
Message-ID: <AANLkTimcLgsdEm6XKESc34Z=nsJkZqz8H1jR-ARZo_Gq@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: handle simple case in free_pcppages_bulk()
From: Minchan Kim <minchan.kim@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 10:18 PM, Namhyung Kim <namhyung@gmail.com> wrote:
> 2011-02-10 (목), 22:10 +0900, Minchan Kim:
>> Hello Namhyung,
>>
>
> Hi Minchan,
>
>
>> On Thu, Feb 10, 2011 at 8:46 PM, Namhyung Kim <namhyung@gmail.com> wrote:
>> > Now I'm seeing that there are some cases to free all pages in a
>> > pcp lists. In that case, just frees all pages in the lists instead
>> > of being bothered with round-robin lists traversal.
>>
>> I though about that but I didn't send the patch.
>> That's because many cases which calls free_pcppages_bulk(,
>> pcp->count,..) are slow path so it adds comparison overhead on fast
>> path while it loses the effectiveness in slow path.
>>
>
> Hmm.. How about adding unlikely() then? Doesn't it help much here?

Yes. It would help but I am not sure how much it is.
AFAIR, when Mel submit the patch, he tried to prove the effectiveness
with some experiment and profiler.
I think if you want it really, we might need some number.
I am not sure it's worth.




-- 
Kind regards,
Minchan Kim
