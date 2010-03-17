Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0CQSgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 14:36:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46232 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753242Ab0CQSgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 14:36:17 -0400
Date: Wed, 17 Mar 2010 18:36:08 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Simon Kagstrom <simon.kagstrom@netinsight.net>, x86@kernel.org,
       linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, alan@linux.intel.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH 1/2]: serial8250: Use native_io_delay on the x86
Message-ID: <20100317183608.600bcdf0@lxorguk.ukuu.org.uk>
In-Reply-To: <4BA11EAA.20506@zytor.com>
References: <20100317132849.7d49939b@marrow.netinsight.se>
	<20100317133050.54851ff8@marrow.netinsight.se>
	<4BA11EAA.20506@zytor.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Mar 2010 11:25:46 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/17/2010 05:30 AM, Simon Kagstrom wrote:
> >   #ifdef __i386__
> > -		outb(0xff, 0x080);
> > +		native_io_delay();
> >   #endif
> 
> There is something a lot more weird about this.  First of all, it's 
> #ifdef'd out on all but __i386__ including x86-64; second, it looks like 
> this is specific to synchronizing to the IER.
> 
> I'm wondering if the right thing isn't to add a dummy write to the SCR 
> register (or similar.)

You just need a write to something on the ISA bus which is 'safe' so that
you don't end up reading back what you wrote to an non-existant port as
some old chipsets will return the last ISA result when you do this rather
than 0xff.
