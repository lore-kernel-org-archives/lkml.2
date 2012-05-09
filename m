Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759970Ab2EIPeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:34:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33924 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501Ab2EIPeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:34:08 -0400
Date: Wed, 9 May 2012 17:34:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Igor Mammedov <imammedo@redhat.com>,
        Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        pjt@google.com, tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
Message-ID: <20120509153403.GB2653@gmail.com>
References: <4FAA588B.5010404@redhat.com>
 <1336564330.2527.23.camel@twins>
 <4FAA5BFB.40309@redhat.com>
 <1336566096.2527.30.camel@twins>
 <1336566644.2527.33.camel@twins>
 <1336570043.2527.38.camel@twins>
 <20120509133607.GA26124@gmail.com>
 <1336571049.2527.43.camel@twins>
 <1336571947.2527.47.camel@twins>
 <1336573182.30189.42.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336573182.30189.42.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Wed, 2012-05-09 at 15:59 +0200, Peter Zijlstra wrote:
> > The current implementation limits both (field_width and precision) to
> > s16, which will limit us to printing 32Kb bitmaps. If need arises we
> > could increase printf_spec size I guess.
> 
> Not sure that's a problem really.
> A single printk is limited to 1024 bytes.
> 
> > diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> []
> > @@ -941,6 +947,26 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
> >  			return netdev_feature_string(buf, end, ptr, spec);
> >  		}
> >  		break;
> > +	case 'b':
> > +		{
> > +			int bits, len;
> 
> trivia: a tab indent could be avoided by using
> 	case b: {

Nit: 'b'.

Thanks,

	Ingo
