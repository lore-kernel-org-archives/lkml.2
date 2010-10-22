Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749Ab0JVAxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:53:32 -0400
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:31113 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752609Ab0JVAxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:53:31 -0400
From: Bruno Randolf <br1@einfach.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH v3] Add generic exponentially weighted moving average (EWMA) function
Date: Fri, 22 Oct 2010 09:53:30 +0900
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; x86_64; ; )
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org,
        kevin.granade@gmail.com, Lars_Ericsson@telia.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
References: <20101020082336.28281.77747.stgit@localhost6.localdomain6> <20101021192658.C8EE.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101021192658.C8EE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010220953.30148.br1@einfach.org>
X-SF-Loop: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu October 21 2010 19:31:47 KOSAKI Motohiro wrote:
> Hi
> 
> I'm plaing this a bit and I have to say this doesn't works as I expected
> because ewma_init() has very easy confusable.
> 
> so, I have one request.
> 
> > +/**
> > + * ewma_init() - Initialize EWMA parameters
> > + * @avg: Average structure
> > + * @factor: Factor to use for the scaled up internal value. The maximum
> > value + *	of averages can be UINT_MAX/(factor*weight).
> > + * @weight: Exponential weight, or decay rate. This defines how fast the
> > + * 	influence of older values decreases. Has to be bigger than 1.
> > + *
> > + * Initialize the EWMA parameters for a given struct ewma @avg.
> > + */
> > +struct ewma*
> > +ewma_init(struct ewma *avg, const unsigned int factor,
> > +	  const unsigned int weight)
> > +{
> > +	WARN_ON(weight <= 1 || factor == 0);
> > +	avg->weight = weight;
> > +	avg->factor = factor;
> > +	return avg;
> > +}
> > +EXPORT_SYMBOL(ewma_init);
> 
> Please initalize avg->internal too.

Oh, sorry! I forgot that!
 
> and nit, I don't understand what you intend by 'const unsigned int'. I
> think we can remove this const safely. it's more easy readable.

O.K. Will resend.

Apart from that, what didn't work as you expected?

Bruno
