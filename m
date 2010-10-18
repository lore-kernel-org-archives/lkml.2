Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884Ab0JRD1M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 23:27:12 -0400
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:4036 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751451Ab0JRD1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 23:27:11 -0400
From: Bruno Randolf <br1@einfach.org>
To: kevin granade <kevin.granade@gmail.com>
Subject: Re: [PATCH] Add generic exponentially weighted moving average function
Date: Mon, 18 Oct 2010 12:27:06 +0900
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>,
        akpm <akpm@linux-foundation.org>
References: <20101006093225.8739.14012.stgit@tt-desk> <201010141019.23547.br1@einfach.org> <AANLkTim+wuzaak=VP3uq=SefGMq_fzr3MR0yF+PKQTdw@mail.gmail.com>
In-Reply-To: <AANLkTim+wuzaak=VP3uq=SefGMq_fzr3MR0yF+PKQTdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010181227.06877.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri October 15 2010 22:55:23 kevin granade wrote:
> >> This has a scaled up copy of the moving average, which reduces the
> >> available range for the average to MAX_INT/(AVG_FACTOR*num_samples)
> >> instead of +/- MAX_INT, is that acceptable?  Even if it is, shouldn't
> >> it be documented?  For example, with num_samples = 10, it will roll
> >> over to a negative value if the average exceeds 214,748.  This seems
> >> like a potentially surprising outcome.
> > 
> > Yes. I'll document this in the next version of the patch. Or should I use
> > 64bit for the internal representation?
> 
> If you don't expect the size or speed impact to be significant, it
> seems like just throwing a bigger number at the problem might be the
> better option.  That will move the rollover to MAX_INT/AVG_FACTOR,
> unless you also make AVG_FACTOR 64bit, which will promote all of the
> multiplications to 64bit and provide full MAX_INT range for input and
> output.

Honestly, I don't know about the speed impact of using 64 bit vs. 32 bit. 
I do know however, that the averaging function needs to be called quite often, 
where I want to use it, so performance could be an issue. And in my case the 
values are low enough so rollover is not a problem - but obviously I want to 
make this generally useful.

> I couldn't find anything that clearly indicated what the expected
> precaution is in this case.  It probably isn't an issue now that I
> understand that samples is intended to remain constant.  I initially
> thought samples would scale from 1 - n as you were initially "loading"
> samples into the structure, but now I understand that samples remains
> at n throughout the process.

I will work on the description.

Thanks,
Bruno
