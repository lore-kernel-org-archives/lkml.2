Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200Ab0EKCpI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 22:45:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932114Ab0EKCpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 22:45:05 -0400
Date: Mon, 10 May 2010 19:43:29 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpuidle: Add a repeating pattern detector to the
 menu governor
Message-Id: <20100510194329.f49eeb96.akpm@linux-foundation.org>
In-Reply-To: <20100510182746.7e923812@infradead.org>
References: <20100509160242.2e351e6a@infradead.org>
	<20100509160444.260ca9c9@infradead.org>
	<20100510143850.fde16046.akpm@linux-foundation.org>
	<20100510182746.7e923812@infradead.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 18:27:46 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> On Mon, 10 May 2010 14:38:50 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > +	if (avg && stddev < STDDEV_THRESH)
> > > +		data->predicted_us = avg;
> > > +}
> > 
> > You got lucky there, because INTERVALS is a power of two.  If someone
> > changes INTERVALS to 7, this code will ask for __udivdi3 and won't
> > link on i364.
> 
> yeah you'd think it almost isn't an accident ;-)

If it was deliberate the code would read

	avg >>= INTERVALS_SHIFT;

:-p
