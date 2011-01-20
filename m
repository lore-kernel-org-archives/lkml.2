Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab1ATSCV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:02:21 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50277 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab1ATSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:02:20 -0500
Date: Thu, 20 Jan 2011 18:01:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: KyongHo Cho <pullip.cho@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        KeyYoung Park <keyyoung.park@samsung.com>,
        linux-kernel@vger.kernel.org, Ilho Lee <ilho215.lee@samsung.com>,
        linux-mm@kvack.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mm: Regarding section when dealing with meminfo
Message-ID: <20110120180146.GH6335@n2100.arm.linux.org.uk>
References: <1295516739-9839-1-git-send-email-pullip.cho@samsung.com> <1295544047.9039.609.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295544047.9039.609.camel@nimitz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 09:20:47AM -0800, Dave Hansen wrote:
> This problem actually exists without sparsemem, too.  Discontigmem (at
> least) does it as well.

We don't expect banks to cross sparsemem boundaries, or the older
discontigmem nodes (esp. as we used to store the node number.)
Discontigmem support has been removed now so that doesn't apply
anymore.

> The x86 version of show_mem() actually manages to do this without any
> #ifdefs, and works for a ton of configuration options.  It uses
> pfn_valid() to tell whether it can touch a given pfn.

x86 memory layout tends to be very simple as it expects memory to
start at the beginning of every region described by a pgdat and extend
in one contiguous block.  I wish ARM was that simple.
