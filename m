Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2ADV4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 16:56:37 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:40867 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031Ab2ADV4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:56:34 -0500
Date: Wed, 4 Jan 2012 21:56:23 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabio Estevam <festevam@gmail.com>, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] include: crash_dump.h: Add elf.h header
Message-ID: <20120104215623.GI11810@n2100.arm.linux.org.uk>
References: <1325678666-13089-1-git-send-email-festevam@gmail.com> <20120104122805.103eb7e2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104122805.103eb7e2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 12:28:05PM -0800, Andrew Morton wrote:
> The patch is the right thing to do, however I'm rather concerned about
> the potential for introducing build breakage so late in 3.2.
> 
> Can we leave this unfixed in 3.2 and fix it in 3.2.1?  Or put a
> #include elf.h into arch/arm/kernel/setup.c for 3.2?

arch/arm/kernel/setup.c doesn't need either of these includes.  The
reason I didn't want to just remove the include and magic the error
away is because of the obvious fragility of the current situation,
which really needs solving.

As this is the only report of this breakage, I'm inclined to go
with your first suggestion: leave it unfixed in 3.2 and fix it in
-stable once it's been in visible for a bit.
