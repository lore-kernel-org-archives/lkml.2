Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760574Ab2FGKpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:45:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:52713 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760026Ab2FGKpm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:45:42 -0400
Message-ID: <1339065932.23343.18.camel@twins>
Subject: Re: [PATCH] perf/x86: check ucode before disabling PEBS on
 SandyBridge
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, mingo@elte.hu,
        ming.m.lin@intel.com
Date: Thu, 07 Jun 2012 12:45:32 +0200
In-Reply-To: <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
References: <20120607071531.GA4849@quad> <1339064319.23343.13.camel@twins>
	 <CABPqkBQ+p5rcuxpXCTLMXPM+awAHhQ6mP9-WzVh5GWtn2GyfrA@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-07 at 12:35 +0200, Stephane Eranian wrote:
> > This will only warn about the PEBS issue once you try and use a PEBS
> > counter. Shouldn't we do this on boot? IOW. put check_pebs_quirks()
> > inside the existing quirk code instead of here?
> >
> The warning could also be done on boot. But the check has to be done
>  when the event is created. 

Is this because of the ucode loader not having done its thing yet etc..?

> The other thing is that as it is now, if you
> get an error, you check dmesg and it's obvious what is wrong. With
> the boot warning, you'd have to look back all the way to the early boot
> messages. Whatever you prefer, I am fine. 

We could do both I guess. But the event creation one needs a rate
limiter.
