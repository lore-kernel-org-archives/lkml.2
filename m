Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab1EMPFm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:05:42 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:44221 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758382Ab1EMPFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:05:41 -0400
Date: Fri, 13 May 2011 16:07:07 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] MIPS: Replace _PAGE_READ with _PAGE_NO_READ
Message-ID: <20110513150707.GA26389@linux-mips.org>
References: <7aa38c32b7748a95e814e5bb0583f967@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7aa38c32b7748a95e814e5bb0583f967@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 09:44:29AM -0700, Kevin Cernekee wrote:

> Reuse more of the same definitions for the non-RIXI and RIXI cases.  This
> avoids having special cases for kernel_uses_smartmips_rixi cluttering up
> the pgtable*.h files.
> 
> On hardware that does not support RI/XI, EntryLo bits 31:30 / 63:62 will
> remain unset and RI/XI permissions will not be enforced.

Nice idea but it breaks on 64-bit hardware running 32-bit kernels.  On
those the RI/XI bits written to c0_entrylo0/1 31:30 will be interpreted as
physical address bits 37:36.

I'm removing this patch series from the 2.6.40 patch queue until we can
sort this out.

  Ralf
