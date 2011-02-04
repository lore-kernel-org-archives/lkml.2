Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1BDJel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 04:34:41 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38185 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab1BDJej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 04:34:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=lXJKita9I6ePTtaYCrk7k1jw3SSC8tFkWWqwvsf01t2qNHNSn0/i5bd6a7MxzdOhCQ
         hNSqy63kQe8/lksN9dIOOkHx1ZW1FUuFqaZE4RynjsHCBlGE5Pm/1UK/H8b/Y9CxjOly
         65yvZ3gztu+tGqBdBNp3XUOrhDux6m7SwrVF8=
Date: Fri, 4 Feb 2011 17:33:32 +0800
From: Richard Zhao <linuxzsc@gmail.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
Message-ID: <20110204093332.GA2347@richard-laptop>
References: <20110201141837.GA1147@pengutronix.de>
 <20110201143932.GK31216@n2100.arm.linux.org.uk>
 <20110201151846.GD1147@pengutronix.de>
 <20110201152458.GP31216@n2100.arm.linux.org.uk>
 <20110201155344.GF1147@pengutronix.de>
 <20110201170637.GR31216@n2100.arm.linux.org.uk>
 <20110201193201.GH1147@pengutronix.de>
 <20110201195604.GS31216@n2100.arm.linux.org.uk>
 <4D486B59.6010106@codeaurora.org>
 <20110201204330.GJ1147@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201204330.GJ1147@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 09:43:31PM +0100, Uwe Kleine-König wrote:
> Hello,
> 
> On Tue, Feb 01, 2011 at 12:21:45PM -0800, Saravana Kannan wrote:
> > If the driver is calling clk_prepare() right next to clk_enable()
> > knowing it's been already prepared and will hence be "atomic" (this
> > is actually not true), then by your description, it's pointless to
> > call clk_prepare().
> Well not completely, as it increases the reference count.  The advantage
> would be that clk_enable counts addionally as prepare, so it would be
> impossible to unprepare an enabled clock.  And the other way round an
> unprepared clock would never be enabled.
>  
> > If you want the driver to call clk_prepare() in atomic context
> > because it will be atomic in most cases -- well, that's wrong. It's
> > either atomic or is NOT atomic. There is no in between. If a call is
> > NOT atomic, it can't be called in atomic context. Long story short,
> > if you expect clk_prepare() to be atomic under any circumstance, it
> > beats the point of introducing clk_prepare().
> Well, with my suggestion it's atomic when certain precondions are given.
> IMHO that's better than "atomic in most cases" because the caller can
> assert that everything goes smooth.
> These preconditions are asserted when the driver writer is careful
> enough to stick to the API.
IMHO, clk_prepare is always called in non-atomic context, so it doesn't matter
whether it's really atomic or not. We don't have to make it as atomic as
possible.

Thanks
Richard
> 
> Either my idea is bad or I'm unable to sell it appropriately.  Be it as
> it is, I will stop to make a case for it.
> 
> Best regards and thanks for your try,
> Uwe
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
