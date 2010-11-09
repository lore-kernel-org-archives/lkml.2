Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125Ab0KIK0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:26:40 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48392 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab0KIK0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:26:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Mcil4AkiJ0TDrbbbwu3ZhbVMMwEJ2JBHsiCSzjM3WSNPvQyR3u6oMVwshoTdTqmKCm
         UwMufRNJC7G13xSyFk+Rhj1jW+Od5RYD2ivEEk6vdIpeof+/YeZT+K/0I0UI1prbdxIB
         IgKdyu2BTLMZzszWkQvQMJSClr9XYRo3wfGhE=
Date: Tue, 9 Nov 2010 11:26:41 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Message-ID: <20101109102641.GB2690@riccoc20.at.omicron.at>
References: <cover.1288897198.git.richard.cochran@omicron.at>
 <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
 <201011080756.50930.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011080756.50930.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 07:56:50AM +0100, Arnd Bergmann wrote:
> On Thursday 04 November 2010, Richard Cochran wrote:
> >  #define CPUCLOCK_PERTHREAD_MASK	4
> >  #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
> >  #define CPUCLOCK_CLOCK_MASK	3
> > @@ -28,12 +40,17 @@ struct cpu_timer_list {
> >  #define CPUCLOCK_VIRT		1
> >  #define CPUCLOCK_SCHED		2
> >  #define CPUCLOCK_MAX		3
> > +#define CLOCKFD			CPUCLOCK_MAX
> > +#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)
> 
> It looks like you are turning a kernel internal interface into a user ABI,
> which I think is highly questionable. Using the bits like this internally is
> ok, but making it part of the syscall ABI means that we can never change this
> in the future.

This set of defines is already part of the ABI and has been copied
into glibc.  I am extending the (mis)use of the clock id by adding one
more case.

Richard


