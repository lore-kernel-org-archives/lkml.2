Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1IUMJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 08:09:42 -0400
Received: from 87-104-106-3-dynamic-customer.profibernet.dk ([87.104.106.3]:49590
	"EHLO kernel.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1IUMJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 08:09:41 -0400
Message-ID: <4E79D404.7000805@kernel.dk>
Date: Wed, 21 Sep 2011 14:09:40 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: xen_biovec_phys_mergeable not exported
References: <20110920202553.GB16740@parisc-linux.org>
In-Reply-To: <20110920202553.GB16740@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-20 22:25, Matthew Wilcox wrote:
> 
> In my NVMe driver, I call BIOVEC_PHYS_MERGEABLE().  If CONFIG_XEN
> is defined, it references xen_biovec_phys_mergeable() which is not
> EXPORT_SYMBOL.  I think BIOVEC_PHYS_MERGABLE is a perfectly kosher thing
> to be calling from a module that implements a bio-based block driver,
> so I think the right thing to do is to add an EXPORT_SYMBOL(_GPL?) to
> the Xen code when I submit the driver.
> 
> Does anyone have a different opinion on this?

Yep, lets just export it for now. Long term, that functionality will be
moving back into the block layer when we unify the queuing models.

-- 
Jens Axboe

