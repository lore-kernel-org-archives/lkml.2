Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751407Ab1IYHeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 03:34:18 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61142 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1IYHeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 03:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <20110923132441.GA10289@redhat.com>
References: <1316142577.29510.130.camel@sli10-conroe>
	<CADX3swqrpz+=JSk8gQf6tDRZ25Z9FOnJbTyiCrZAM6LiJSmoGA@mail.gmail.com>
	<1316155239.29510.148.camel@sli10-conroe>
	<CADX3swqAq=zpFtWogbuRnARjjZK753esKihs3tzLQkbiRE2y0Q@mail.gmail.com>
	<1316603780.2001.12.camel@shli-laptop>
	<20110923132441.GA10289@redhat.com>
Date: Sun, 25 Sep 2011 09:34:16 +0200
Message-ID: <CADX3swpctg-yENZE0178x5SS3PTKB3qZE+=vEfNJwqydxLJ95g@mail.gmail.com>
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 3:24 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Sep 21, 2011 at 07:16:20PM +0800, Shaohua Li wrote:
>
> [..]
>> > Try a workload with one shallow seeky queue and one deep (16) one, on
>> > a single spindle NCQ disk.
>> > I think the behaviour when I submitted my patch was that both were
>> > getting 100ms slice (if this is not happening, probably some
>> > subsequent patch broke it).
>> > If you remove idling, they will get disk time roughly in proportion
>> > 16:1, i.e. pretty unfair.
>> I thought you are talking about a workload with one thread depth 4, and
>> the other thread depth 16. I did some tests here. In an old kernel,
>> without the deep seeky idle logic, the threads have disk time in
>> proportion 1:5. With it, they get almost equal disk time. SO this
>> reaches your goal. In a latest kernel, w/wo the logic, there is no big
>> difference (the 16 depth thread get about 5x more disk time). With the
>> logic, the depth 4 thread gets equal disk time in first several slices.
>> But after an idle expiration(mostly because current block plug hold
>> requests in task list and didn't add them to elevator), the queue never
>> gets detected as deep, because the queue dispatch request one by one.
>
> When the plugged requests are flushed, then they will be added to elevator
> and at that point of time queue should be marked as deep?
>
> Anyway, what's wrong with the idea I suggested in other mail of expiring
> a sync-noidle queue afer few reuqest dispatches so that it does not
> starve other sync-noidle queues.
I don't know the current state of the code. Are the noidle queues
sorted in some tree, by sector number?
If that is the case, then even an expired queue could still be in
front of the tree.
>
> Thanks
> Vivek
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
