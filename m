Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab1H3TwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 15:52:16 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:22225 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab1H3TwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 15:52:13 -0400
Date: Tue, 30 Aug 2011 21:52:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Joe Perches <joe@perches.com>
Cc: Richard Kuo <rkuo@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-hexagon@vger.kernel.org
Subject: Re: [patch v2 09/35] Hexagon: Add checksum functions
Message-ID: <20110830195211.GA10415@merkur.ravnborg.org>
References: <20110830190729.923334292@codeaurora.org> <20110830190800.574002538@codeaurora.org> <1314732887.14422.10.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314732887.14422.10.camel@Joe-Laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 12:34:47PM -0700, Joe Perches wrote:
> On Tue, 2011-08-30 at 14:07 -0500, Richard Kuo wrote:
> > Removed most non-assembly functions and use the generic ones instead.
> []
> > +++ linux-hexagon-kernel/arch/hexagon/include/asm/checksum.h	2011-08-24 18:45:48.133877105 -0500
> []
> > +#define do_csum	do_csum
> 
> That looks pretty odd.
> I have a hard time believing that's useful or necessary.

This is "the new way" to tell that an arch supply an arch specific variant of a function.
See lib/checksum.c.

It does:

#ifndef do_csum
...
#endif

So archs that do not define do_csum will get a generic version of do_csum.
And "do_csum" nicely shows up in grep - so it makes sense to do so.

	Sam
