Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab0HJSB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 14:01:28 -0400
Received: from 8bytes.org ([88.198.83.132]:43784 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249Ab0HJSBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 14:01:23 -0400
Date: Tue, 10 Aug 2010 20:01:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.35] AMD-Vi: Enabling IOMMU at 0000:00:00.2 cap 0x40  BUG:
	unable to handle kernel NULL pointer dereference at 0000000000000198
Message-ID: <20100810180122.GR23755@8bytes.org>
References: <1154489525.20100810164850@eikelenboom.it> <20100810162606.GQ23755@8bytes.org> <419601760.20100810185745@eikelenboom.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <419601760.20100810185745@eikelenboom.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 06:57:45PM +0200, Sander Eikelenboom wrote:
> The requested info is attached.
> So that would mean a bios problem ? (those are not on my wishlist :-p)

Yeah, looks like a BIOS problem. But the driver should handle that
without crashing the system, so there is a bug in the driver too.

Problem is:

AMD-Vi:   DEV_ALIAS_RANGE         devid: 0a:01.0 flags: 00 devid_to: 0a:00.0
AMD-Vi:   DEV_RANGE_END           devid: 0a:1f.7

This means that PCI devices from 0a:01.0 to 0a:1f.7 may use their own
device-id or 0a:00.0. But a device which id 0a:00.0 is not present in
the system. From the lspci output this looks like your USB3 controler
should alias to 09:00.0. I prepare a patch for you to fix the crash but
I can't guarantee that your USB3 controler will work afterwards. If you
see IO-Page-Faults please report them to me.

	Joerg

