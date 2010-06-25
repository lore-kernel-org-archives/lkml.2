Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159Ab0FYHTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 03:19:44 -0400
Received: from n1-vm1.bullet.mail.gq1.yahoo.com ([67.195.23.153]:42043 "HELO
	n1-vm1.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751734Ab0FYHTn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 03:19:43 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 814390.52930.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=jm1haSOZNbsJVzzV2vTLEnQqgo3T+wouZt5lYRbCIXD+JpvJtBMeOmPvFHe+o3zCCRvIb6adG3DYt55Omjx691hd/AVc3qGiBHk3BF43XCeGaTidytZSsgZUNv8PxocTBlpA8mvB76c7uqx1pS/RLKD7mPKI5A8xXKoQwhZVYyA=;
Message-ID: <683567.34621.qm@web180314.mail.gq1.yahoo.com>
X-YMail-OSG: GqNdJfwVM1kYs6wh4_EVDamLIyyoarGh8zUhE4Pi.Uvtoj1
 dN55hqE15BpFgw03hZa5u.l2K3Zu1m237qJRntbDsJ.EodVsVE2foxrlhjNg
 OJcffT2xtljxYZ8I3qR4bUTQq8_HJIFr_jT7sLJoMKkFyq6iYOIjJXEzYgvh
 6HMIw5MM8Ta_vlwMireuha_ivlSYktF4cG6bvIBEfRI7OXrwJ9qWC7xQ8U0P
 f4o3qhihmff8.ur8W7Ktx1yCPAqY4vMeaSkUaxyAM1egg.Mdk36J3R823ONF
 lv2xGDBVs9Bi2iLE76_T3oX2pJVVFJ1ZhuJUgDW57MIyadcZnf10ajfPM7TZ
 LXquJsYOERZTH7cxMjuBhN5.G6P1hENarbIs-
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.104.274457
Date: Fri, 25 Jun 2010 00:19:41 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [RFC PATCH] Rework gpio cansleep (was Re: gpiolib and sleeping gpios)
To: Jamie Lokier <jamie@shareable.org>, Ryan Mallon <ryan@bluewatersys.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux kernel <linux-kernel@vger.kernel.org>,
       ext-jani.1.nikula@nokia.com,
       =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <4C22A275.3030102@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 6/23/10, Ryan Mallon <ryan@bluewatersys.com> wrote:

> >> In the current code, if a driver ever calls
> gpio_(set/get)_value on a
> >> gpio then you cannot pass a sleeping gpio to that
> driver. The request
> >> will succeed,

No it won't.  Recall that those bit accessor
functions don't return success or failure!!

I'll be submitting a patch soonish, which is
a variant of Jani's patch to make the runtime
warnings trigger more consistently in the
face of such programming errors.




