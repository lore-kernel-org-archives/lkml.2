Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760394Ab2C3B0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 21:26:37 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:53711 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759324Ab2C3B0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 21:26:32 -0400
Date: Fri, 30 Mar 2012 10:27:27 +0900
From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/2] linux: ARM: memmap: Revise freeing unused memmap entries for SPARSEMEM
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20120329121313.GF22414@n2100.arm.linux.org.uk>
References: <20120329190252.3895.38390934@jp.panasonic.com> <20120329121313.GF22414@n2100.arm.linux.org.uk>
Message-Id: <20120330102727.3F01.38390934@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 13:13:14 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Mar 29, 2012 at 07:02:52PM +0900, Akira Takeuchi wrote:
> > F0-F4 is the unused memory regions and their corresponding memmap entries
> > can be freed. However, free_unused_memmap() only frees the entries for
> > F1/F2/F4, and does not free the entries for F0/F3.
> 
> No we're not going to support having free areas at the start of an
> otherwise populated bank of memory.  This is just insane.  Fix your
> hardware instead or your sparsemem setup.

As you say, it is able to reduce the number of unused entries remained
by setting SECTION_SIZE_BITS smaller.
On the other hand, I think it's not always true to assign whole memory
to Linux. In some cases, there are free areas at the start of populated
bank of memory and these free areas are assigned to sub CPUs or DSPs
for example. Recent CE SoCs are apt to include multiple CPUs and DSPs
sharing memory among them. This patch is beneficial for such systems,
I think.


Regards,
Akira Takeuchi

