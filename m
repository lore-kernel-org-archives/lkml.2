Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab0LJLyr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 06:54:47 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46543 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab0LJLyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 06:54:46 -0500
Date: Fri, 10 Dec 2010 06:54:41 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org
Subject: Re: [PATCH] Update MCP55 quirk to not affect non HyperTransport
 variants
Message-ID: <20101210115441.GB13606@hmsreliant.think-freely.org>
References: <1291819668-15624-1-git-send-email-nhorman@tuxdriver.com>
 <20101209154041.8a54dba8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209154041.8a54dba8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Spam-Score: -4.2 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 09, 2010 at 03:40:41PM -0800, Andrew Morton wrote:
> On Wed,  8 Dec 2010 09:47:48 -0500
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > I wrote this quirk awhile ago to properly setup MCP55 chips on hypertransport
> > busses so that interrupts reached whatever cpu happend to boot the kdump kernel.
> > while that works well, it was recently shown to me that a a non-hypertransport
> > variant of the MCP55 exists, and on those system the register that this quirk
> > manipulates causes hangs if you write to it.  Since the quirk was only meant to
> > handle errors found on MCP55 chips that have a HT interface, this patch adds a
> > filter to make sure the chip is an HT capable before making the needed register
> > adjustment.  This lets the broken MCP55s work with kdump while not breaking the
> > non-HT variants.
> > 
> > Resolves https://bugzilla.kernel.org/show_bug.cgi?id=23952
> > 
> > Tested successfully by the reporter and myself.
> > 
> > Reported-by: Mathieu B__rard <mathieu@mberard.eu>
> > CC: linux-pci@vger.kernel.org
> > CC: kexec@lists.infradead.org
> > CC: Vivek Goyal <vgoyal@redhat.com>
> > CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> That needed a Cc:<stable@kernel.org> as well.  Please don't forget to
> remember -stable.
Thanks, Cc'ing stable on the thread

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
