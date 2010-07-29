Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab0G2T5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:57:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58253 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab0G2T5t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PVezscbelB+e4HWUvYzz3Were2M+JbXAbhTrcyiMS5Xe6j5wlmD66PuHIyW6zkfp2g
         Ckf4WfDDAyi70V5Sc5NXeQ/6pSJ4DEvEDsUq36skqDS/ErUoH7zTrGhgYgvPtoEfb1rI
         jruYfSHiotFNNCJ6tJFiJfM+PkWxiFcJgCtkA=
MIME-Version: 1.0
In-Reply-To: <20100726143300.GG12449@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
	<20100722055602.GA18566@infradead.org>
	<20100722140044.GA28684@redhat.com>
	<20100724085135.GB32006@infradead.org>
	<AANLkTi=d-2-1R_Bpk_1J7AXhTc2Kv3p8S7tE0ZsFKFDe@mail.gmail.com>
	<20100726143300.GG12449@redhat.com>
Date: Thu, 29 Jul 2010 21:57:43 +0200
Message-ID: <AANLkTinwcGdvp-Q+-dqNHAjL1O4oDbi-8GkyyV=k6-Pc@mail.gmail.com>
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle 
	tunable V3
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 4:33 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Sat, Jul 24, 2010 at 11:07:07AM +0200, Corrado Zoccolo wrote:
>> On Sat, Jul 24, 2010 at 10:51 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> > To me this sounds like slice_idle=0 is the right default then, as it
>> > gives useful behaviour for all systems linux runs on.
>> No, it will give bad performance on single disks, possibly worse than
>> deadline (deadline at least sorts the requests between different
>> queues, while CFQ with slice_idle=0 doesn't even do this for readers).
>
> Not sure if CFQ will be worse than deadline with slice_idle=0. CFQ has
> some inbuilt things which should help.
>
> - Readers preempt Writers
> - All writers go in one single queue (at one prio level), readers get
>  their individual queues and can outnumber writers.
>
> So I guess CFQ with slice_idle=0 should not be worse than deadline in terms
> of read latencies.

I was thinking more to the fact that read requests are not sorted:
they will basically be serviced in FIFO order, while deadline will
sort them and possibly increase locality. In the reader vs writer
case, cfq may have a small edge. Basically, they will severely
underperform vs. cfq with slice != 0, though.

>
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
