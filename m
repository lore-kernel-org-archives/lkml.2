Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab0JVB2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:28:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33500 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534Ab0JVB2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:28:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bruno Randolf <br1@einfach.org>
Subject: Re: [PATCH v3] Add generic exponentially weighted moving average (EWMA) function
Cc: kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
        akpm@linux-foundation.org, kevin.granade@gmail.com,
        Lars_Ericsson@telia.com, blp@cs.stanford.edu,
        linux-kernel@vger.kernel.org
In-Reply-To: <201010221025.30164.br1@einfach.org>
References: <20101022100316.53A3.A69D9226@jp.fujitsu.com> <201010221025.30164.br1@einfach.org>
Message-Id: <20101022102718.53A6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 22 Oct 2010 10:28:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri October 22 2010 10:11:38 KOSAKI Motohiro wrote:
> > few additional reviewing comments is here.
> > 
> > > +struct ewma {
> > > +	unsigned int internal;
> > > +	unsigned int factor;
> > > +	unsigned int weight;
> > > +};
> > 
> > I think unsigned long is better because long is natual register size
> > on both 32bit and 64bit arch.
> > and, example, almost linux resource limit is using long or ulong. then
> > uint may have overflow risk if we are using this one on 64bit arch.
> > Does uint has any benefit? (note: scheduler loadavg has already used ulong)
> 
> You know more about this than me. I have no specific reason to use unsigned 
> int. I'll change it to unsigned long, if that's better.

Thank you.


> > > +struct ewma*
> > > +ewma_add(struct ewma *avg, const unsigned int val)
> > > +{
> > > +	avg->internal = avg->internal  ?
> > > +		(((avg->internal * (avg->weight - 1)) +
> > > +			(val * avg->factor)) / avg->weight) :
> > > +		(val * avg->factor);
> > > +	return avg;
> > 
> > Hm, if ewma_add has this function prototype, we almost always need to
> > typing "new = ewma_get(ewma_add(&ewma, val))". Is this intentional?
> > if so, why?
> >
> > Why can't we simple do following?
> > 
> > unsigned long ewma_add(struct ewma *avg, const unsigned int val)
> > {
> > (snip)
> > 	return ewma_get(avg);
> > }
> 
> Hmm, I guess that depends on the way you want to use it. In my case, most of 
> the times when I add a value to the average, I don't need to get the value. 
> I'd call ewma_add() many more times than ewma_get(). Having the functions 
> defined like this gives us the flexibility to choose and IMHO  
> ewma_get(ewma_add(&ewma, val)) isn't so bad?

OK. I've got it. I agree we don't change this. Thank you for very
quick responce!



