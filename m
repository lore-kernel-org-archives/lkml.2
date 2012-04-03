Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab2DCQSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:18:07 -0400
Received: from mail.vyatta.com ([76.74.103.46]:34981 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab2DCQSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:18:05 -0400
Date: Tue, 3 Apr 2012 09:17:50 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] marvell sky2 driver: fix so it works without unaligned
 accesses
Message-ID: <20120403091750.11eff45b@s6510.linuxnetplumber.net>
In-Reply-To: <201204031527.q33FR04i031747@farm-0027.internal.tilera.com>
References: <201204031527.q33FR04i031747@farm-0027.internal.tilera.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2012 11:13:56 -0400
Chris Metcalf <cmetcalf@tilera.com> wrote:

> The driver uses a receive_new() routine that ends up requiring unaligned
> accesses in IP header processing.  If the architecture doesn't support
> efficient unaligned accesses, just copy all ingress packets to the bounce
> buffers instead.
> 
> This allows the driver to be used on the Tilera TILEmpower-Gx, since
> the tile architecture doesn't currently handle kernel unaligned accesses,
> just userspace.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

There are many other encapsulation cases where IP header won't be
aligned. Why not just set copybreak module option to a very large value?
