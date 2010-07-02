Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab0GBLUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 07:20:15 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:45259 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0GBLUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 07:20:12 -0400
Date: Fri, 2 Jul 2010 13:21:41 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Dan Kruchinin <dkruchinin@acm.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: Re: [PATCH 2/2] pcrypt: sysfs interface
Message-ID: <20100702112141.GJ10072@secunet.com>
References: <20100629203939.29a0b4ff@leibniz>
 <20100630124742.GD10072@secunet.com>
 <AANLkTimSgp_5LwfvECaAFnW-_UwxwsYVEjKcZTDIHadx@mail.gmail.com>
 <20100702090801.GG10072@secunet.com>
 <AANLkTinFqMtdfvbYDIGjQHoWa3dmUuruTvxG-upUU-7S@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinFqMtdfvbYDIGjQHoWa3dmUuruTvxG-upUU-7S@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Jul 2010 11:20:02.0769 (UTC) FILETIME=[83F4F410:01CB19D8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 02:20:15PM +0400, Dan Kruchinin wrote:
> >
> > Yes, I thought about something like this. You can still take the sum
> > over the percpu objects when you output the statistics.
> 
> But summation can not be clear without some kind of lock because
> while we're summing another CPU can increase or decrease its percpu statistic
> counters. Then each statistic percpu counter must be modified under lock, right?
> 

Yes, the counters must accessed under lock. In the fastpath functions you 
hold the appropriate lock anyway. Modifying a local percpu value should
not be too painfull there.

The expensive thing is to access the percpu statistics, but this happens
on demand and is probaply a rare event.

Steffen
