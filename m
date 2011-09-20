Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194Ab1ITUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:25:56 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:40540 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1ITUZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:25:55 -0400
Date: Tue, 20 Sep 2011 14:25:53 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>
Subject: xen_biovec_phys_mergeable not exported
Message-ID: <20110920202553.GB16740@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In my NVMe driver, I call BIOVEC_PHYS_MERGEABLE().  If CONFIG_XEN
is defined, it references xen_biovec_phys_mergeable() which is not
EXPORT_SYMBOL.  I think BIOVEC_PHYS_MERGABLE is a perfectly kosher thing
to be calling from a module that implements a bio-based block driver,
so I think the right thing to do is to add an EXPORT_SYMBOL(_GPL?) to
the Xen code when I submit the driver.

Does anyone have a different opinion on this?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
