Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab1IINEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 09:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299Ab1IINE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 09:04:28 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Fri, 9 Sep 2011 09:04:17 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.35.14-96.fc14.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Neil Horman <nhorman@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <201109080911.12921.sgrubb@redhat.com> <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com>
In-Reply-To: <CACXcFmnnMLHq2VE35i4QK4wNePXHJc6T73VQNTmJo7WEz34DaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201109090904.18321.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 08, 2011 10:21:13 PM Sandy Harris wrote:
> > The system being low on entropy is another problem that should be
> > addressed. For our purposes, we cannot say take it from TPM or RDRND or
> > any plugin board. We have to have the mathematical analysis that goes
> > with it, we need to know where the entropy comes from, and a worst case
> > entropy estimation.
> 
> Much of that is in the driver code's comments or previous email
> threads. For example,
> this thread cover many of the issues:
> http://yarchive.net/comp/linux/dev_random.html
> There are plenty of others as well.
> 
> > It has to be documented in detail.
> 
> Yes. But apart from code comments, what documentation
> are we talking about? Googling for /dev/random on tldp.org
> turns up nothing that treats this in any detail.

Thanks for the reply. I see that you are trying to be helpful. But I think you 
misunderstand what I was trying to say or maybe I was not entirely clear. We have the 
correct analysis for the kernel and it does indeed pass FIPS-140, unaided. We know the 
entropy comes from what the minimum entropy estimation is, and quality. (The only 
issue is guaranteeing that any seed source must also include entropy.) 

But what I was trying to say is that we can't depend on these supplemental hardware 
devices like TPM because we don't have access to the proprietary technical details 
that would be necessary to supplement the analysis. And when it comes to TPM chips, I 
bet each chip has different details and entropy sources and entropy estimations and 
rates. Those details we can't get at, so we can't solve the problem by including that 
hardware. That is the point I was trying to make. :)

Thanks,
-Steve
