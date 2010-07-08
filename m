Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0GHPP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 11:15:26 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53652 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab0GHPPW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 11:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vg2WzNHUUhOhYCRz0oXVg7uLSyp6JOwGWMUC7fYWTBdUCoCnS1yRoSVDcD1Fc46Djm
         FEIsNcFtqYst1Mzf+7hlBYjEZxZGtoGCPHbZtGeIhM5Cd3p0iVfVH88bm/IX4ekHWueR
         TWoWVempuKuV6k+SjgGNXx+jesgWOFRAyPqx8=
MIME-Version: 1.0
In-Reply-To: <x49r5jedq1f.fsf@segfault.boston.devel.redhat.com>
References: <20100707230521.GB7842@redhat.com>
	<x4939vuf5y6.fsf@segfault.boston.devel.redhat.com>
	<20100708135625.GD5093@redhat.com>
	<x49r5jedq1f.fsf@segfault.boston.devel.redhat.com>
Date: Thu, 8 Jul 2010 17:15:17 +0200
Message-ID: <AANLkTilFB5Z6Gd6xMtFXJ4lmFB4qLQfIs0kjoDcLYtMS@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] cfq-iosched: Implement cfq group idling
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Nauman Rafique <nauman@google.com>,
       Divyesh Shah <dpshah@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 8, 2010 at 4:08 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
>
>> On Thu, Jul 08, 2010 at 09:39:45AM -0400, Jeff Moyer wrote:
>>> Vivek Goyal <vgoyal@redhat.com> writes:
>>>
>>> > Currently we idle on sequential queues and allow dispatch from a single
>>> > queue and that can become a bottleneck on higher end storage. For example
>>> > on my HP EVA, I can run multiple sequential streams and achieve top BW
>>> > of around 350 MB/s. But with CFQ, dispatching from single queue does not
>>> > keep the array busy (limits to 150-180 MB/s with 4 or 8 processes).
>>> >
>>> > One approach to solve this issue is simply use slice_idle = 0. But this
>>> > also takes away the any service differentiation between groups.
>>>
>>> That also takes away service differentiation between queues.  If you
>>> want to maintain that at all, then this is really just pushing the
>>> problem to another layer.
>>>
>>
>> Yes it does take away the io priority with-in group. But I think that's
>> the trade-off and that's not default. So those who don't require ioprio
>> stuff working with-in group and those who know that they have got
>> faster storage will set slice_idle=0. For rest of the SATA users default
>> is still slice_idle=8.
>
> [snip]
>
> Sorry, Vivek, I'm actually hijacking your thread.  ;-)  I know what the
> alternatives are, what I'm looking for is guidance on what Jens wants to
> do with CFQ.  We can discuss the merits of different approaches once we
> agree on a set of requirements.
>
> Cheers,
> Jeff
>

Hi Jeff,
did you have a look at:
http://lkml.indiana.edu/hypermail/linux/kernel/1004.3/00082.html (and
following msgs)?
We tried to achieve better throughput on multi-spindle disks, by merging queues.
I think the idea is promising, but we still need a lot of work to make
it concrete.
If you want to hack on it, feel free, since I don't have hardware to test it.

Corrado

__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
