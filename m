Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab0HDL1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:27:41 -0400
Received: from n4.bullet.mail.ac4.yahoo.com ([76.13.13.28]:25862 "HELO
	n4.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756972Ab0HDL1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:27:39 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 166393.20035.bm@omp125.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=vUMSDwscOyNBSo7mEeHMnEpiIeS7kefrsTgC8Aikod7gSPXhsdXC7Ccq7MaJDzBm2c8M1TUP64VrlReB9Hd8hMXl36qeEZbLnVyRJcGIP+QD7QXPchkVpxXPkhcDGrVXVl8n1H8c79SA3lkMtYpbup+TZONGFUKVzhvA7mQI85M=;
Message-ID: <30519.93306.qm@web180312.mail.gq1.yahoo.com>
X-YMail-OSG: ishKH3UVM1l5m0HDu0RZzuqChZYj6GlNOlgtMy_f2l81lz4
 CD1JBPF._KxusdxAqtpVvmd..fMeLvsX3i9X95Z2H2BsPmKSIOyjgITm1yUV
 9Y44YAUv8SX0nuDg6f4Z1_CsueTWH5VM7DxNYF3Uc3isk_fn26eq52ypDdhs
 JerGaEwuXcM7rtHW1wgOhczRmahSQI3ztTDhjVIpR_4M0r8PRWyiASY2ER6i
 iJ.og185PE4tNtQK5n39CQN_2zVaUfFrbGGz.9BHE7qJMCFJryADj1UPXJHZ
 qLa.6sIRvqDyp6BSDSmeYT91Y5ENrmRpXlAB1LItHtfbi_K3EMxguUsXwmCy
 Kru.znauQhAyINRHj.G0-
X-Mailer: YahooMailClassic/11.3.2 YahooMailWebService/0.8.105.279950
Date: Wed, 4 Aug 2010 04:27:38 -0700 (PDT)
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
In-Reply-To: <1280920127.19499.20.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Wed, 8/4/10, David Woodhouse <dwmw2@infradead.org> wrote:

> > Point is to ensure that enough of the right context
> > information is available to initialize correctly.
> > So the right data is extracted and passed on.


And also, ISTR, that the mechanism is general
enough to work with both MTD and EEPROM ...

> 
> Forgive me if I'm being dim (and in particular, please
> forgive me if I'm
> going over something that was already discussed; I know
> it's been a
> while).

I also am at risk of getting lost in a pile
of hypotheticals which have been left behind
earlier in these threads.

 But I don't see why it needs to be passed through
> the core MTD  code.
> 
> To take the simple case of an unpartitioned MTD device --
> why can't the
> map driver (or whatever) just call the maccessor setup
> function for
> itself, directly, right after calling add_mtd_device() with
> its newly-probed MTD device?

No idea, except that doing it once rather than
modifying every driver would seem healthier.
Surely changing all drivers is a Bad Thing.

> 
> And for partitions, why can't it do the same, on the
> appropriate partition.
> 
> OK, the answer to the latter question is that you don't
> actually *have*
> the pointers to each partition you register. But that's
> easily fixed.
> 
> If we make add_mtd_partitions() take an extra 'struct
> mtd_info **'
> argument and put pointers to the slave mtd 'devices' into
> that, it means
> that your board driver *can* reliably get the mtd pointer
> for the fourth
> partition, or whatever it needs. And can then just do the
> memory
> accessor setup for itself.
> 
> Isn't that enough?

Might be.  Not my patch though...  You asked why
the context was needed along with the partition
data (otherwise not available); I answered.

Still haven't seen a better patch though.





