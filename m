Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab0EMXuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:50:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:45380 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311Ab0EMXup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:50:45 -0400
Subject: Re: [PATCH 1/2] mtdpart: memory accessor interface for MTD layer
From: David Woodhouse <dwmw2@infradead.org>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: linux-mtd@lists.infradead.org, Bernd Schmidt <bernd.schmidt@analog.com>,
       David Howells <dhowells@redhat.com>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Nicolas Pitre <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1268772081-6534-1-git-send-email-khilman@deeprootsystems.com>
References: <1268772081-6534-1-git-send-email-khilman@deeprootsystems.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 00:50:29 +0100
Message-ID: <1273794629.9999.412.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 13:41 -0700, Kevin Hilman wrote:
> From: Sudhakar Rajashekhara <sudhakar....@ti.com>
> 
> This patch implements memory accessor interface in the MTD
> layer which enables the kernel to access flash data.
> 
> This patch adds two new members to the mtd_partition structure,
> a function handler which will be called during setup of the
> partition and an argument to be passed to this setup function.

Ick.

I don't mind providing the mtd_macc_{read,write} helper functions,
although they should work on generic MTD devices not just on partitions.
But do we really have to do the callout to arbitrary functions from
_within_ the core MTD code... why can't we do that in the board driver?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

