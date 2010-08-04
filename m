Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab0HDLJB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 07:09:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:60038 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932201Ab0HDLJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 07:09:00 -0400
Subject: RE: [PATCH 1/2] mtdpart: memory accessor interface for MTD layer
From: David Woodhouse <dwmw2@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: "'Kevin Hilman'" <khilman@deeprootsystems.com>,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        "'Bernd Schmidt'" <bernd.schmidt@analog.com>,
        "'Nicolas Pitre'" <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        "'David Howells'" <dhowells@redhat.com>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        linux-mtd@lists.infradead.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>
In-Reply-To: <350720.60481.qm@web180309.mail.gq1.yahoo.com>
References: <350720.60481.qm@web180309.mail.gq1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 12:08:47 +0100
Message-ID: <1280920127.19499.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 03:31 -0700, David Brownell wrote:
> Point is to ensure that enough of the right context
> information is available to initialize correctly.
> So the right data is extracted and passed on.

Forgive me if I'm being dim (and in particular, please forgive me if I'm
going over something that was already discussed; I know it's been a
while). But I don't see why it needs to be passed through the core MTD
code.

To take the simple case of an unpartitioned MTD device -- why can't the
map driver (or whatever) just call the maccessor setup function for
itself, directly, right after calling add_mtd_device() with its
newly-probed MTD device?

And for partitions, why can't it do the same, on the appropriate
partition.

OK, the answer to the latter question is that you don't actually *have*
the pointers to each partition you register. But that's easily fixed.

If we make add_mtd_partitions() take an extra 'struct mtd_info **'
argument and put pointers to the slave mtd 'devices' into that, it means
that your board driver *can* reliably get the mtd pointer for the fourth
partition, or whatever it needs. And can then just do the memory
accessor setup for itself.

Isn't that enough?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


