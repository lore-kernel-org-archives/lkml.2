Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab0ETOCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:02:00 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61613 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab0ETOB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=rJA6Ujd9zB58k+xhmqxXElGSHNlUm8UFEZtDjy8qIKSuJat6UWYfMhCMKKRzRmCvHe
         X1/3PK5V7Y0rb9hpbbYZnvWBQmt6sBbgzN/RUCpij+eL8jYTu0AxBS81SZ+cU+afyJ73
         D70Ddrr0PGr6tnJ4+28y9QwMpsPMwdp3/TME4=
MIME-Version: 1.0
In-Reply-To: <20100520131844.GA10298@redhat.com>
References: <20100519203336.GB3394@redhat.com>
	 <AANLkTimL7SjlZW5qxylc2MdygYugTFgDVdMM-N-E0tk0@mail.gmail.com>
	 <20100520131844.GA10298@redhat.com>
Date: Thu, 20 May 2010 16:01:55 +0200
Message-ID: <AANLkTinEaQtA-Kw-7CedvNyVL8w1ybDnvkjZZ8g8ORaN@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: Revert the logic of deep queues
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Moyer Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 20, 2010 at 3:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, May 20, 2010 at 01:51:49AM +0200, Corrado Zoccolo wrote:
> Hi Corrado,
>
> Deep queues can happen often on high end storage. One case I can think of is
> multiple kvm virt machines running and doing IO using AIO.
>
> I am not too keen on introducing a tunable at this point of time. Reason
> being that somebody having a SATA disk and driving deep queue depths is
> not very practical thing to do. At the same time we have fixed a theoritical
> problem in the past. If somebody really runs into the issue of deep queue
> starving other random IO, then we can fix it.
>
> Even if we have to fix it, I think instead of a tunable, a better solution
> would be to expire the deep queue after one round of dispatch (after
> having dispatched "quantum" number of requests from queue). That way no
> single sync-noidle queue will starve other queues and they will get to
> dispatch IO very nicely without intorducing any bottlenecks.

Can you implement this solution in the patch? It seems that this will
solve both the performance issue as well as non-reintroducing the
theoretical starvation problem.
If we don't mind some more tree operations, the queue could be expired
at every dispatch (if there are other queues in the service tree),
instead of every quantum dispatches, to cycle through all no-idle
queues more quickly and more fairly.

Thanks,
Corrado

>
> Thanks
> Vivek
>
