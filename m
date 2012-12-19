Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2LSBbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 20:31:47 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:41972 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab2LSBbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 20:31:42 -0500
X-Greylist: delayed 1306 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 20:31:42 EST
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1212181641050.3932@chino.kir.corp.google.com>
References: <1355876729-25627-1-git-send-email-dianders@chromium.org>
	<alpine.DEB.2.00.1212181641050.3932@chino.kir.corp.google.com>
Date: Tue, 18 Dec 2012 17:02:56 -0800
X-Google-Sender-Auth: -gcPhjujd16ADucZ1W2j418n7tE
Message-ID: <CAD=FV=WoGfuqCoVnDh-hPA-OL-7xp1eLN6RBHT_XePFDs5V24A@mail.gmail.com>
Subject: Re: [PATCH] block: Avoid divide by 0 when max_discard_sectors is 0
From: Doug Anderson <dianders@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Neil Brown <neilb@suse.de>, Tejun Heo <tj@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Tue, Dec 18, 2012 at 4:42 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 18 Dec 2012, Doug Anderson wrote:
>
>> The recent commit "block: discard granularity might not be power of 2"
>> introduced a divide by 0 in the kernel.  Previously the code didn't
>> try to divide by discard_granularity when max_discard_sectors was 0.
>>
>> Fix the code to only do the division if max_discard_sectors is
>> specified.
>>
>
> Could you try Linus' patch at
> http://marc.info/?l=linux-kernel&m=135584941732572 and give your Tested-by
> if it solves your issue?

Hoo boy.  Thanks for the pointer.  I missed that when searching to see
if this had already been fixed.  :(

I'm pretty sure Linus's patch will fix my problem since I think my
system has "max_discard_sectors" as 0 and his patch has the same
effect as mine: avoid the divide by 0.  Someone else will need to test
his patch on a system that actually uses discard.  In any case, I will
test and send a Tested-by as soon as I'm able.

Please consider my patch abandoned.

>
> Thanks.
