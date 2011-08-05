Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1HETWj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 15:22:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59901 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756268Ab1HETWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 15:22:36 -0400
Date: Fri, 5 Aug 2011 20:22:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andres Salomon <dilinger@queued.net>
Cc: linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>, dsd@laptop.org,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Mitch Bradley <wmb@laptop.org>, "H. Peter Anvin" <hpa@zytor.com>,
        eric.y.miao@gmail.com
Subject: Re: [PATCH RFC v1] ARM: olpc: Add support for calling into the
	XO-1.75's OpenFirmware (OFW)
Message-ID: <20110805192213.GC28958@n2100.arm.linux.org.uk>
References: <20110804162551.2b92b2cf@debxo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110804162551.2b92b2cf@debxo>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 04:25:51PM -0700, Andres Salomon wrote:
> Add support for saving OFW's cif, and later calling into it to run OFW
> commands from the kernel.  OFW remains resident in memory after boot,
> and the physical/virtual addresses are passed in a boot tag.

If you have open firmware, then you probably have a device tree being
passed to the kernel.  In that case, there aren't any boot tags being
passed.  So I think this patch is rather inconsistent.

Also I believe we had decided that ARM is not going to support the
runtime bits of DT/open firmware stuff.  Unless open firmware is aware
of the setup of the kernel mappings (which would then tie it directly
to the running kernel) it can't access any hardware resources.  I'm
not willing to have external binary blobs (whether or not the source
is available) having a dependency on the setup of the kernel page
tables.  Given that we are consolidating across all platforms, it's
likely that we will want to change the virtual address layout over time
and to have some external binary blob is just going to be a complete
nightmare.

So I really don't like this idea.  At all.
