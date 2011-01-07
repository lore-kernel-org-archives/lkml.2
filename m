Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1AGNAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 08:00:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52612 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1AGNAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 08:00:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=V3XD/SLi8Hj15THPAkM67aIJi/762m3EDqmR1x5ykEimvyCmGscbsfJgg1Kzkfk2v/
         NSwUbXEjgeLK6VObYQWHfWz05PiKjgvl0oNVs7ufBfKnU2vkO0thSVqFlqRQmO2KHdLn
         4XQ1hWlHlMjpVpRXydonPG48ghWSA5wmT7AJQ=
MIME-Version: 1.0
In-Reply-To: <4D26CCEE.4070508@kernel.dk>
References: <AANLkTimHE35jUOY6Lhd7OnATSD6BeB4poUosaQ+bR61i@mail.gmail.com>
	<4D26CCEE.4070508@kernel.dk>
Date: Fri, 7 Jan 2011 08:00:45 -0500
Message-ID: <AANLkTingF8jK2Lppng+MCeszB=KFEsqs9uRqBn0Uhdh8@mail.gmail.com>
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

I add a tracepoint so that I can get nr_sorted and in_flight[0/1] of
request_queue when request is completed, I consider nr_sorted as the
number of pending requests and in_flight[0/1] represent the number
serving in the storage. Does these two parameters stand for what I
mean?

The test benchmark I use is postmark which simulates the email server
system, over 90% requests are small random write. The storage is Intel
M SSD. Generally, I think the number of in_flight[0/1] should be much
greater than 1, but the result shows that this value is almost 1 no
matter what I/O scheduler(CFQ/DEADLINE/NOOP) or
filesystem(EXT4/EXT3/BTRFS) it is. Is it normal?

B.T.W, I only run a process for postmark.

> The driver has to take care of this. Since requests are pulled by the
> driver, it knows when to stop asking for more work.
>
> BTW, your depth of 4 for the HDD seems a bit odd. Typically all SATA
> drives share the same queue depth, limited by what NCQ provides (32).
>

This number is given arbitrary, just for example.

Thanks,
Yuehai
