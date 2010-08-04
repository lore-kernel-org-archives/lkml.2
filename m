Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab0HDKbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:31:47 -0400
Received: from n79.bullet.mail.sp1.yahoo.com ([98.136.44.39]:21988 "HELO
	n79.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756983Ab0HDKbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:31:46 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 450026.80024.bm@omp124.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=yk2eYdCYWN0zJgZ54KEVEZlCnaiEp44v9XNR1XICdW+/3RXgU0Y8pBHfpRlBtqq67sFjyq8XWa//MBXaCvehEZ4Ju6aHKUhT17NpxhE7uYOu/gPKNaCkOvFChSb0GV99sgYH8W1skDrLHVypcCvsJB/ytwuU+CepWUlfiQ+Zgwc=;
Message-ID: <350720.60481.qm@web180309.mail.gq1.yahoo.com>
X-YMail-OSG: 3FQv.nkVM1k1MvkkUdoXeh3Z4WassdhfVD.JpQg_3U.MCmH
 fuEDmV8LFR.l47LC7zTGsjg90ubKNnFcuZaZo7_WkjjwqzrOPcsg6LKestVa
 kV2vJiyPp1xycdGITZgPYWP0954NIhmzZ5bi5FbJVaK3IMoOoRvJ_._wcZ4X
 eyjugtiP_thlDku2oT4pTnbqetOXGs3cCd2cE.An31KYbCkxD8NE6b6fHZqG
 rBDmvu.p9X6WuEt8C19AmnDIbZHHRUBOrHBzYGKNsKG1QZSCARyUltBNo_4U
 FrVCBSxmmu4eI6i3Y5zY0y3j4N8FZn6P14HXzVoIeMNACZj1N.T3a5mZRy2a
 mysjZgFO1Dp.umxWp_QDdCEqddkb_TVOQ
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 4 Aug 2010 03:31:45 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: RE: [PATCH 1/2] mtdpart: memory accessor interface for MTD layer
To: David Woodhouse <dwmw2@infradead.org>
Cc: "'Kevin Hilman'" <khilman@deeprootsystems.com>,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        "'Bernd Schmidt'" <bernd.schmidt@analog.com>,
        "'Nicolas Pitre'" <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        "'David Howells'" <dhowells@redhat.com>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        linux-mtd@lists.infradead.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>
In-Reply-To: <1280916725.19499.12.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 8/4/10, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2010-07-07 at 04:08 -0700,
> David Brownell wrote:
> > 
> > I think the short answer is that the callout is
> > what provides the board drivers enough information
> > to make the correct calls. 

EMPHASIS ON "CORRECT" ...

> I don't see how.
> 
> The only information it passes to the callout is the
> information it was
> already *given* in the partition structure.

There can be multiple such structures, each
of which describes different data to be extracted
from different persistent media contexts.

Examples:  one context holds one MAC address (and
another, a different one) ... another might embed
calibration data; another, serial numbers; etc.

Pass the wrong context around, you've trashed all
the data instead of getting it right.


> I'm more inclined to believe Sudhakar's claim that you'll
> get an
> 'initialization sequence problem', although I'm not sure I
> believe it
> can't be solved in a better way than this.

"Initialization sequence" is a grab-bag category
that covers most init issues.

Point is to ensure that enough of the right context
information is available to initialize correctly.
So the right data is extracted and passed on.


> 
> I'm also unhappy that it only works on partitioned devices
> -- that seems wrong.

Very different issue.  Seems easily fixable
if needed.  Agreed that e.g. EEPROMS won't
often be partitioned (unlike flash).



