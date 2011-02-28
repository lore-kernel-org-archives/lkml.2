Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab1B1LTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:19:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57087 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab1B1LTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:19:52 -0500
Date: Mon, 28 Feb 2011 11:19:49 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: John Linn <john.linn@xilinx.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, catalin.marinas@arm.com, glikely@secretlab.ca,
        jamie@jamieiles.com, arnd@arndb.de
Subject: Re: [PATCH V4 0/4] ARM: Basic Xilinx Support
Message-ID: <20110228111949.GC2754@pulham.picochip.com>
References: <0d410c20-32b4-46d6-9639-249a2816cbe9@VA3EHSMHS005.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d410c20-32b4-46d6-9639-249a2816cbe9@VA3EHSMHS005.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 11:14:37AM -0700, John Linn wrote:
> 
> V4
> 
> I incorporated more feedback from Jamie Iles. It was 
> primariy cleanup with the only significant change
> being a move to using raw_read/write in the uncompressor
> uart code.
> 
> The other changes were minor updates so that the patch
> set applies to linux-next.
> 
> This patch set is now tested against the linux-next branch
> from pub/scm/linux/kernel/git/sfr/linux-next.git.

Hi John,

I've just tried a quick dummy build of this series (with a fudge in 
mach-types to get it building) and I see a couple of minor sparse 
warnings:

arch/arm/mach-xilinx/common.c:54:13: warning: symbol 
'xilinx_system_init' was not declared. Should it be static?
arch/arm/mach-xilinx/common.c:68:13: warning: symbol 'xilinx_irq_init' 
was not declared. Should it be static?
arch/arm/mach-xilinx/common.c:110:13: warning: symbol 'xilinx_map_io' 
was not declared. Should it be static?
arch/arm/mach-xilinx/timer.c:290:18: warning: symbol 'xttcpss_sys_timer' 
was not declared. Should it be static?

I think all of these can be resolved by including "common.h" in both 
timer.c and common.c.

I've put a couple of nitpicks for the individual patches, sorry I didn't 
spot them before.  Otherwise,

Reviewed-by: Jamie Iles <jamie@jamieiles.com>

Jamie
