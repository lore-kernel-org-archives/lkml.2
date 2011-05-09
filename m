Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1EIOd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:33:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46638 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab1EIOd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:33:56 -0400
Date: Mon, 9 May 2011 10:33:52 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <greg@kroah.com>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: various vmbus review comments
Message-ID: <20110509143352.GB29635@infradead.org>
References: <20110503204641.GA11132@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DFCFA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110504163228.GA19754@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481E0694@TK5EX14MBXC124.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481E0694@TK5EX14MBXC124.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 01:10:38PM +0000, KY Srinivasan wrote:
> I audited the block and the net drivers. As part of their exit routine,
> they invoke vmbus_child_driver_unregister() after properly cleaning
> up all the devices they are managing. Do you still see an issue with
> regards to module reference counting.

Which is not the correct thing to do as explained in my last round
of reviews.  Take a look at the PCI code - the functional driver only
does a foo_untegister_driver (which maps almost directly to
driver_unregister), which then causes the device core to unbind the
devices.  The function driver must never call device_unregister
directly as the device continues to exist even if no driver is bound to
it.

