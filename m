Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1C1PJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:09:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45507 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1C1PJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:09:03 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=P8oO77IduGQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=4mKUGaAQlxIajzjjqoQA:9 a=v0z5VNEijwzVzELvJmHilz5XPdYA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Add comment to explain ({0;})
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        adobriyan@gmail.com, linux-tip-commits@vger.kernel.org
In-Reply-To: <4D90A1FE.4000405@zytor.com>
References: <tip-ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870@git.kernel.org>
	 <4D90A08D.707@zytor.com>
	 <AANLkTinh6nraZND1mQJ4ofPbABOtJNEnGYYEkqs92RQM@mail.gmail.com>
	 <4D90A1FE.4000405@zytor.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 28 Mar 2011 11:09:00 -0400
Message-ID: <1301324940.14261.232.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 07:58 -0700, H. Peter Anvin wrote:
> On 03/28/2011 07:56 AM, richard -rw- weinberger wrote:
> >>
> >> What the heck is wrong with the idiomatic and non-gcc-extension-using:
> >>
> >>        ((void)0)
> >>
> >> ?
> > 
> > AFAIK you cannot use it within an if-statement.
> > 
> 
> OK, fair enough.

If people hate the ({0;}) so much, we could replace it with:

static inline int _WARN_ON_SMP(void) { return 0; }
#define WARN_ON_SMP(x) _WARN_ON_SMP()

That would pretty much do the same thing.

 o Keeps the parameters from being evaluated, as they may not be defined
   for SMP

 o Can be used as a standalone statement without gcc complaining

 o Can be used within an if condition.

Geeze, I never expected such a fuss over a simple change ;)


-- Steve


