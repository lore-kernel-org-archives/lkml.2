Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab2HDIkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 04:40:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54350 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2HDIkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 04:40:02 -0400
Date: Sat, 4 Aug 2012 09:39:46 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, catalin.marinas@arm.com, nico@linaro.org,
        will.deacon@arm.com
Subject: Re: [PATCH 00/22] Introducing the TI Keystone platform
Message-ID: <20120804083945.GB6802@n2100.arm.linux.org.uk>
References: <1343775898-28345-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343775898-28345-1-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 07:04:36PM -0400, Cyril Chemparathy wrote:
> This series is a follow on to the RFC series posted earlier (archived at [1]).
> The major change introduced here is the modification to the kernel patching
> mechanism for phys_to_virt/virt_to_phys, in order to support LPAE platforms
> that require late patching.  In addition to these changes, we've updated the
> series based on feedback from the earlier posting.
> 
> Most of the patches in this series are fixes and extensions to LPAE support on
> ARM. The last three patches in this series are specific to the TI Keystone
> platform, and are being provided here for the sake of completeness.  These
> three patches are dependent on the smpops patch set (see [2]), and are not
> ready to be merged in as yet.

Can you explain why you want the kernel loaded above the 4GB watermark?
This seems silly to me, as the kernel needs to run at points with a 1:1
physical to virtual mapping, and you can't do that if the kernel is
stored in physical memory above the 4GB watermark.

