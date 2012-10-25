Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935084Ab2JYRv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 13:51:58 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:26725 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934720Ab2JYRv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:51:56 -0400
Message-ID: <1351187513.2662.9.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] tilegx: fix some issues in the SW TSO support
From: Ben Hutchings <bhutchings@solarflare.com>
To: Chris Metcalf <cmetcalf@tilera.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2012 18:51:53 +0100
In-Reply-To: <201210251737.q9PHbgev032681@farm-0012.internal.tilera.com>
References: <201210251737.q9PHbgev032681@farm-0012.internal.tilera.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 13:25 -0400, Chris Metcalf wrote:
> This change correctly computes the header length and data length in
> the fragments to avoid a bug where we would end up with extremely
> slow performance.  Also adopt use of skb_frag_size() accessor.
[...]

By the way, since you're doing soft-TSO you should probably set
net_device::gso_max_segs, as explained in:

commit 30b678d844af3305cda5953467005cebb5d7b687
Author: Ben Hutchings <bhutchings@solarflare.com>
Date:   Mon Jul 30 15:57:00 2012 +0000

    net: Allow driver to limit number of GSO segments per skb

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

