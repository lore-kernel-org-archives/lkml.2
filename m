Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab1HKPHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:07:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:59535 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1HKPHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:07:40 -0400
Subject: Re: [PATCH 2/2] Enable 'make CONFIG_FOO=y oldconfig'
From: David Woodhouse <dwmw2@infradead.org>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>, Andreas Schwab <schwab@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
In-Reply-To: <CACqU3MVUeHTZ+cQYucYd8TvGoUOrwVhpxVpho-fqz3MkBTCTMQ@mail.gmail.com>
References: <1312067499.22074.59.camel@i7.infradead.org>
	 <4E4280BA.9050109@suse.cz> <1312981658.2989.39.camel@i7.infradead.org>
	 <CACqU3MUJkM3Y2o2Jx1eQxZkW2T-Dby1JCaks6SqTz_FB17hSvw@mail.gmail.com>
	 <1312985888.2989.46.camel@i7.infradead.org>
	 <CACqU3MXozgu0kr-4w=bGejcEi8MrxH-PhKa0Ji0zrLu7ZEFomg@mail.gmail.com>
	 <1312993987.2989.53.camel@i7.infradead.org>
	 <CACqU3MXC_eDqgWDwnVe8KsqoAMTPQNiP6YMHD5G+1sMBhMwXzA@mail.gmail.com>
	 <1312999168.2989.61.camel@i7.infradead.org>
	 <CACqU3MWB+4n5Acd-GboH5WbCzfZFiAc0wNvOkn_5O+--7jLE8A@mail.gmail.com>
	 <1313002322.2989.88.camel@i7.infradead.org>
	 <CACqU3MU2J25q-wWJ8LNcMkwi3uMigz_+0=XcrNiPC0TGiJHZqA@mail.gmail.com>
	 <1313018232.2989.114.camel@i7.infradead.org>
	 <CACqU3MVyjzr47N9v23SGaSjiEOGoEaP1-TZ4Z_RyVNgVXgPEwg@mail.gmail.com>
	 <1313052168.18037.9.camel@i7.infradead.org> <4E4399B3.3020909@suse.cz>
	 <1313061012.18037.17.camel@i7.infradead.org> <m3r54std0x.fsf@hase.home>
	 <1313062813.18037.24.camel@i7.infradead.org> <4E43C363.3000103@suse.cz>
	 <CACqU3MVUeHTZ+cQYucYd8TvGoUOrwVhpxVpho-fqz3MkBTCTMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 16:07:23 +0100
Message-ID: <1313075243.5632.6.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 10:57 -0400, Arnaud Lacombe wrote:
> 
> FWIW, this is the broken behavior I have been pointing all along...
> 
> If kconfig hard failed on such case, we would not need such Kbuild
> black-magic.
> 
> From my point of view, if environment override there should be, it
> should behave the same as the all.config logic and hard fail when an
> override has not been met. 
> Code wise, this would translate as backend code path being the same. 
 

The patches I have so far *do* behave the same as the all.config logic,
because the back end code *is* fairly much the same. I was looking at
the all.config logic when I wrote the patch to kconfig.

It *doesn't* currently hard fail. But I'm more than happy to make it do
so. I think you're right; that makes most sense.

I've just been looking at ways to allow real build targets to proceed
*only* if any config options specified on the command line *did* get
honoured by kconfig. But that gets a bit messy since you also want to
automatically trigger an 'oldconfig' run if anything was specified on
the command line. So you end up with one automatic oldconfig run in a
sub-make, then the *second* time around it when the supposedly identical
submake is invoked for the real build target, it would have to behave
differently.

I'm much happier with automatically triggering a reconfig if options are
given on the command line, and a hard fail if they can't be honoured.

That means that 'make CONFIG_FOO=y bzImage' will work 'properly', which
IMO is either to do as it was asked, or fail.

-- 
dwmw2

