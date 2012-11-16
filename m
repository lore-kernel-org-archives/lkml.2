Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2KPXxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 18:53:16 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:52514 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab2KPXxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 18:53:15 -0500
Date: Sat, 17 Nov 2012 00:53:08 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] regmap: introduce tables for readable/writeable/volatile/precious checks
Message-ID: <20121116235308.GE27012@mail.gnudd.com>
References: <1352983612-3474-1-git-send-email-ciminaghi@gnudd.com> <20121116011904.GH4387@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121116011904.GH4387@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 10:19:07AM +0900, Mark Brown wrote:
> On Thu, Nov 15, 2012 at 01:46:52PM +0100, ciminaghi@gnudd.com wrote:
> 
> > I haven't seen any reply up to now, so I'm just resending the original patch
> > (see https://lkml.org/lkml/2012/10/25/224).
> > I just applied it to today's next and did a quick re-test.
> 
> The fact that you don't send a real name in your patch submission mails
> might be an issue here - I suspect you've fallen foul of spam filtering,
> either automatic or human, there's no sign of this in my pending queue.
>
mmm maybe I did something wrong with git send-email. Will check, thanks for
pointing this out.
 
> > +static inline bool _reg_in_ranges(unsigned int reg,
> > +				  const struct regmap_range *ranges,
> > +				  unsigned int nranges)
> > +{
> > +	const struct regmap_range *r;
> > +	int i;
> > +
> > +	for (i = 0, r = ranges; i < nranges; i++, r++)
> > +		if (_reg_in_range(reg, r))
> > +			return true;
> > +	return false;
> > +}
> 
> It would be better to make this an externally visible function (perhaps
> just move it into the header with a regmap on the front of the name) so
> that drivers can use this as part of the implementation of more complex
> checks.  Otherwise this looks fine.

ok, I'll fix the patch and resend it next week.

Thanks and regards
Davide

