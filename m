Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab1BXTZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:25:15 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38362 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1BXTZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:25:09 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=7fdJUjABhSQA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=LK_QS28-zRdYMgWlxPsA:9 a=D0t2i6O86gfeCT2cFSI_TOZs7jQA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] staging: remove null checks before kfree
From: Steven Rostedt <rostedt@goodmis.org>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Greg KH <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTinBFFU5c_kcXGSnJA-ycY6j7EeKvwAFb59iWMHn@mail.gmail.com>
References: <1298364821-18915-1-git-send-email-imirkin@alum.mit.edu>
	 <20110224160828.GA888@home.goodmis.org> <20110224170619.GA7925@suse.de>
	 <1298568347.6376.3.camel@gandalf.stny.rr.com>
	 <AANLkTinBFFU5c_kcXGSnJA-ycY6j7EeKvwAFb59iWMHn@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 24 Feb 2011 14:25:06 -0500
Message-ID: <1298575506.6376.4.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 19:08 +0000, Ilia Mirkin wrote:

> FWIW my reasoning for doing this was that generally the reason you're
> freeing something is because you allocated it, so kfree(NULL) happens
> rarely -- error paths, conditional features, etc. If you actually
> expect the argument to be NULL often, then you would do something like
> if (unlikely(x)) kfree(x). This is done a few times in the core
> kernel. I think it makes more sense for kfree to keep the unlikely
> since in cold paths it won't matter and in hot paths where it is often
> NULL, there should be a conditional at the call site. [I'm sure you'll
> note the lack of an attached benchmark... this is just what makes
> sense to me.]

That unlikely has been there for years, and another year wont hurt
anything ;)

I'll run my unlikely clean up again in December, and we'll see what
needs to be touched then.

Thanks,

-- Steve


