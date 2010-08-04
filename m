Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0HDJVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 05:21:25 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59013 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0HDJVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 05:21:22 -0400
Date: Wed, 4 Aug 2010 05:21:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Christoph Hellwig <hch@infradead.org>, linux-raid@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: How to track down abysmal performance ata - raid1 - crypto -
 vg/lv - xfs
Message-ID: <20100804092122.GA2998@infradead.org>
References: <20100804073546.GA7494@comet.dominikbrodowski.net>
 <20100804085039.GA11671@infradead.org>
 <20100804091317.GA27779@isilmar-3.linta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804091317.GA27779@isilmar-3.linta.de>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 11:13:17AM +0200, Dominik Brodowski wrote:
> > show these problems?
> 
> No, 2.6.31 to 2.6.34 show similar behaviour.

Ok, so it's been around for a while.  Can you test the write speed of
each individual device layer by doing a large read from it, using:

	dd if=<device> of=/dev/null bs=8k iflag=direct

where device starts with the /dev/sda* device, and goes up to the MD
device, the dm-crypt device and the LV.  And yes, it's safe to read
from the device while it's otherwise mounted/used.

