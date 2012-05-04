Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310Ab2EDWJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:09:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56547 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756625Ab2EDWJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:09:40 -0400
Message-ID: <1336169378.11505.10.camel@joe2Laptop>
Subject: Re: drivers: Probable misuses of ||
From: Joe Perches <joe@perches.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 04 May 2012 15:09:38 -0700
In-Reply-To: <20120504220241.GA6279@sirena.org.uk>
References: <1333580415.23520.29.camel@joe2Laptop>
	 <1336168477.11505.6.camel@joe2Laptop> <20120504220241.GA6279@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-04 at 23:02 +0100, Mark Brown wrote:
> On Fri, May 04, 2012 at 02:54:37PM -0700, Joe Perches wrote:
> > On Wed, 2012-04-04 at 16:00 -0700, Joe Perches wrote:
> 
> > > drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
> > > drivers/media/dvb/dvb-usb/it913x.c:		if (ret == 0 || ret != -EBUSY || ret != -ETIMEDOUT)
> > > drivers/media/rc/fintek-cir.c:	if ((chip != 0x0408) || (chip != 0x0804))
> 
> > It's been a month.
> 
> > Do you maintainers not care
> > about these obvious defects?
> 
> It'd probably help if you were to supply more analysis as to what the
> issues you think you're seeing are - in the cases quoted above
> (especially the last one) there's no obvious bug without further
> analysis.

Likely the || should be &&.

	if (val != foo || test != bar)

is always true when foo != bar


