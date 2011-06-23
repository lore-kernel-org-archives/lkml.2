Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab1FWPCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:02:12 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:43891 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264Ab1FWPCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:02:11 -0400
Date: Thu, 23 Jun 2011 17:02:09 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier@gentoo.org>, Sam Ravnborg <sam@ravnborg.org>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: __packed vs. __attribute__((packed)) in kernel headers
Message-ID: <20110623150209.GA12413@x4.trippels.de>
References: <20110622063441.GA1740@x4.trippels.de>
 <20110623134209.GA10813@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623134209.GA10813@elliptictech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.06.23 at 09:42 -0400, Nick Bowler wrote:
> On 2011-06-22 08:34 +0200, Markus Trippelsdorf wrote:
> > One possible solution would be to let the "scripts/headers_install.pl"
> > script automatically substitute __packed with __attribute__((packed)):
> > 
> > diff --git a/scripts/headers_install.pl b/scripts/headers_install.pl
> > index efb3be1..e0dc065 100644
> > --- a/scripts/headers_install.pl
> > +++ b/scripts/headers_install.pl
> > @@ -35,6 +35,7 @@ foreach my $file (@files) {
> >  		$line =~ s/([\s(])__iomem\s/$1/g;
> >  		$line =~ s/\s__attribute_const__\s/ /g;
> >  		$line =~ s/\s__attribute_const__$//g;
> > +		$line =~ s/\s__packed/__attribute__((packed))/g;
> >  		$line =~ s/^#include <linux\/compiler.h>//;
> >  		$line =~ s/(^|\s)(inline)\b/$1__$2__/g;
> >  		$line =~ s/(^|\s)(asm)\b(\s|[(]|$)/$1__$2__$3/g;
> > 
> > Any thoughts?
> 
> Without any comment on the approach itself, the above change will eat a
> space character before __packed, which may break the header by merging a
> preceding token into the __attribute__.  It may also change instances of
> __packed that occur as a prefix of a longer token.
> 
> Note that the __attribute_const__ lines above it take some care to avoid
> both of these situations.

Yes, you're right. But the patch was meant as a rough proof of concept
and not as the final implementation. 

I'm not an expert of Perl regular expressions, but maybe this:
 $line =~ s/\s__packed;$/ __attribute__((packed));/g
is a little bit closer to the intention?

-- 
Markus
