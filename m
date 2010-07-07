Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553Ab0GGLI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 07:08:57 -0400
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:48792 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753867Ab0GGLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 07:08:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 169281.15684.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=6UZy/9E34L24Amei6BiAoUNqXRxNyB+sHMGMQGvl+sH/vpLBLEEsblrvC1yw/ekX/UO627ji6mS3Z8iF6oTQOS/UwAHOX1VfszSXS2GJt/8xkuy62KVVAIrQD7HtoF35ldwA3002OQAyyRbR9ybrgo3jY2CpQXs6tKCA49nrHhE=;
Message-ID: <54038.80733.qm@web180305.mail.gq1.yahoo.com>
X-YMail-OSG: KCjV2JsVM1miAxtv4dpbD5JuvSA3PR5Fue6N0yn91kgRJ9X
 l9qtNItx3RpkkE6y7bRXkf6qT7BlqtC5DJQbv_KVZsxeLOhxeWdDZZ1tCxaU
 iEkStPK_fwqBUjZ3df0HBAHvo6gaWIOxMdQy2ytkHaWCTAcW0KqeFOC.imTF
 ckNEUW2zMNzyVNSXHoZhwn5fhDl0wAYEF8h3cychMlxypCf5m.mIiDzSFB8C
 nD.7iQdhdaSJGIUu217RvP2_fXHE27YsNMkQDzGT0CGYcR.CIbtT5NRFVg9g
 A4Ecuhw6NEgUnnvjSC24-
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.274457
Date: Wed, 7 Jul 2010 04:08:54 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: RE: [PATCH 1/2] mtdpart: memory accessor interface for MTD layer
To: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Kevin Hilman'" <khilman@deeprootsystems.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>
Cc: "'Bernd Schmidt'" <bernd.schmidt@analog.com>,
       "'Nicolas Pitre'" <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
       "'David Howells'" <dhowells@redhat.com>,
       "'David Brownell'" <dbrownell@users.sourceforge.net>,
       linux-mtd@lists.infradead.org,
       "'Andrew Morton'" <akpm@linux-foundation.org>
In-Reply-To: <012f01cb1dc3$09584880$1c08d980$@raj@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > This patch adds two new members to the
> mtd_partition structure,
> > > a function handler which will be
> > > called during setup of the
> > > partition and an argument to be passed to this
> setup function.
> > 
> > Ick.
> > 
> > I don't mind providing the mtd_macc_{read,write}
> helper functions,
> > although they should work on generic MTD
> > >devices not just on partitions.
> > But do we really have to do the callout to
> > arbitrary functions from
> > _within_ the core MTD code... why can't we
> > do that in the board driver?

I think the short answer is that the callout is
what provides the board drivers enough information
to make the correct calls.


