Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933911Ab1CaKut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 06:50:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757277Ab1CaKur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 06:50:47 -0400
Message-ID: <4D945C4D.5090104@redhat.com>
Date: Thu, 31 Mar 2011 12:49:49 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Robin Holt <holt@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
        Yinghai Lu <yinghai@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC 2/2] Make x86 calibrate_delay run in parallel.
References: <20101215015840.390204279@gulag1.americas.sgi.com> <20101215015849.051095242@gulag1.americas.sgi.com> <AANLkTinoctZFKo4wBmrrdFggnjSj74QfqvEpz59sW15x@mail.gmail.com> <20110331065036.GC5938@elte.hu> <20110331065805.GG5938@elte.hu> <20110331093723.GE24046@sgi.com> <20110331095705.GA23319@elte.hu> <4D9457BF.1040601@redhat.com> <20110331104601.GA8577@elte.hu>
In-Reply-To: <20110331104601.GA8577@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 12:46 PM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
> >  On 03/31/2011 11:57 AM, Ingo Molnar wrote:
> >  >>
> >  >>   I am not trying to be argumentative.  I never got an understanding of
> >  >>   what was going wrong with that earlier patch and am hoping for some
> >  >>   understanding now.
> >  >
> >  >  Well, if calibrate_delay() calls run in parallel then different
> >  >  hyperthreads will impact each other.
> >
> >  It's different but not more wrong.  If delay() later runs on a thread whose
> >  sibling is busy, it will in fact give more accurate results.
>
> No, it's actively wrong: because it makes the delay loop *run faster* when
> other siblings
>
> I.e. this shortens udelay(X)s potentially, which is far more dangerous than the
> current conservative approach of potentially *lengthening* them.
>
> >  >  Really, there's no good reason why every CPU should be calibrated on a
> >  >  system running identical CPUs, right? Mixed-frequency systems are rather
> >  >  elusive on x86.
> >
> >  Good point.  And udelay() users are probably not sensitive to accuracy anyway
> >  (which changes with load and thermal conditions).
>
> True with one important distinction: they are only sensitive to one fact, that
> the delay should not be *shorter* than specified. By shortening udelay() we
> essentially overclock the hardware's tolerances - not good.
>

Makes sense.  But I think the thermally controlled cpu frequency 
violates this in some way - if calibration is run while the cpu is how 
and udelay is later run when it is cool then it could execute faster.

How important is udelay() for hardware timing these days, btw?

-- 
error compiling committee.c: too many arguments to function

