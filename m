Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1AGNXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:23:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51377 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1AGNXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:23:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=PhINfJ6584ZMY9cOqZODb7iOl1gsoxGPxntJdaxpHCu2uIoCRFFv4RyLFzaebD1rso
         gT13KdDGSe92KHpfj7JsEklSEK4t3Aj7e3PV48GekfshymEX/kMXAftnWsFAPHhXcuM4
         EjpoBDfm1PEJqBUSRGr+v7Z6CUowEcJlvZ9NE=
MIME-Version: 1.0
In-Reply-To: <4D2710DC.9050908@kernel.dk>
References: <AANLkTimHE35jUOY6Lhd7OnATSD6BeB4poUosaQ+bR61i@mail.gmail.com>
	<4D26CCEE.4070508@kernel.dk>
	<AANLkTingF8jK2Lppng+MCeszB=KFEsqs9uRqBn0Uhdh8@mail.gmail.com>
	<4D2710DC.9050908@kernel.dk>
Date: Fri, 7 Jan 2011 08:23:43 -0500
Message-ID: <AANLkTi=ZV4-vb7qEbGn=mm6Nz0Jg=XT5YogD=0HNTSdW@mail.gmail.com>
Subject: Re: Who does determine the number of requests that can be serving
 simultaneously in a storage?
From: Yuehai Xu <yuehaixu@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, cmm@us.ibm.com, rwheeler@redhat.com,
        vgoyal@redhat.com, czoccolo@gmail.com, yhxu@wayne.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 8:10 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> Please don't top-post, thanks.

I am really sorry for that.

>
> On 2011-01-07 14:00, Yuehai Xu wrote:
>> I add a tracepoint so that I can get nr_sorted and in_flight[0/1] of
>> request_queue when request is completed, I consider nr_sorted as the
>> number of pending requests and in_flight[0/1] represent the number
>> serving in the storage. Does these two parameters stand for what I
>> mean?
>
> nr_sorted is the number of requests that reside in the IO scheduler.
> That means requests that are not on the dispatch list yet. in_flight is
> the number that the driver is currently handling. So I think your
> understanding is correct.
>
> If you look at where you added your trace point, there are already a
> trace point right there. I would recommend that you use blktrace, and
> then use btt to parse it. That will give you all sorts of queueing
> information.

Yes, but I notice that the original traces can't get nr_sorted and
in_flight[0/1] directly, so I just add few lines. The result is from
the blktrace, and I use blkparse to analysis it, it should be the same
as what you said about btt(I don't know it, sorry about that).

>
>> The test benchmark I use is postmark which simulates the email server
>> system, over 90% requests are small random write. The storage is Intel
>> M SSD. Generally, I think the number of in_flight[0/1] should be much
>> greater than 1, but the result shows that this value is almost 1 no
>> matter what I/O scheduler(CFQ/DEADLINE/NOOP) or
>> filesystem(EXT4/EXT3/BTRFS) it is. Is it normal?
>
> Depends, do you have more requests pending in the IO scheduler? I'm
> assuming you already verified that NCQ is active and working for your
> drive.
>

Yes, the nr_sorted(num of pending requests) remains around 100. hdparm
shows that the NCQ has been enabled.

Thanks,
Yuehai
