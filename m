Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0EQMKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:10:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:34954 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0EQMKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:10:00 -0400
Subject: Re: [PATCH] perf_events: fix errors path in perf_output_begin()
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       acme@infradead.org, perfmon2-devel@lists.sf.net, eranian@gmail.com
In-Reply-To: <AANLkTilJH8RnWjBIY7vrOnXi7w1_z8j9_abD-8tuwL-u@mail.gmail.com>
References: <4bf11ea4.dd29e30a.026d.4627@mx.google.com>
	 <20100517114605.GB5291@nowhere>
	 <AANLkTil2QBjH2qvnH7VKrg6s7RcKvHC1m0HZkDVDPzv5@mail.gmail.com>
	 <1274097780.5605.4642.camel@twins>
	 <AANLkTilJH8RnWjBIY7vrOnXi7w1_z8j9_abD-8tuwL-u@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 May 2010 14:09:35 +0200
Message-ID: <1274098175.5605.4661.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-17 at 14:04 +0200, Stephane Eranian wrote:
> 
> > So you want to preserve this state for when you munmap() and mmap()
> > again? The only user of data->lost is writing the PERF_RECORD_LOST
> > event, which only ever happens when you have pages, so counting it when
> > there's no pages seems futile.
> 
> You're right. But couldn't you report lost samples in the buffer header as well?

I guess you could, but what's the point? If you ask for sampling but
don't provide a buffer you don't get anything -- how's that a surprise?
