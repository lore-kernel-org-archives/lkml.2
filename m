Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab2FUAIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:08:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:46147 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757472Ab2FUAIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:08:15 -0400
Message-ID: <1340237254.28143.201.camel@pasglop>
Subject: Re: [PATCH v2 2/7] iommu: IOMMU Groups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, bhelgaas@google.com, aik@ozlabs.ru,
        david@gibson.dropbear.id.au, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        gregkh@linuxfoundation.org, ddutile@redhat.com, liuj97@gmail.com
Date: Thu, 21 Jun 2012 10:07:34 +1000
In-Reply-To: <1340210921.5076.76.camel@bling.home>
References: <20120530201424.31527.33142.stgit@bling.home>
	 <20120530201852.31527.23265.stgit@bling.home>
	 <1340186501.28143.158.camel@pasglop> <1340210921.5076.76.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-20 at 10:48 -0600, Alex Williamson wrote:

> Yes, I was assuming the caller held a reference to the struct device to
> prevent such a race, looks like I forgot to document that in the
> comments.  I'll have to think about if we can fix the ordering problem.
> We can re-order the list_add vs notification, but then we just risk
> dropping the remove.  Perhaps we need to extend the lock or add another
> to group {list add, notify add}, {list lookup, remove, notify remove}.
> I'm not even sure this race is possible though w/ a device reference.

Or we put the burden on the callers not to racily add & remove,
including full completion of related notifiers. Might not even be hard
(ie might already be the case).

Cheers,
Ben.


