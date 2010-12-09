Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab0LIXlf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 18:41:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756661Ab0LIXld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 18:41:33 -0500
Date: Thu, 9 Dec 2010 15:40:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] Update MCP55 quirk to not affect non HyperTransport
 variants
Message-Id: <20101209154041.8a54dba8.akpm@linux-foundation.org>
In-Reply-To: <1291819668-15624-1-git-send-email-nhorman@tuxdriver.com>
References: <1291819668-15624-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Dec 2010 09:47:48 -0500
Neil Horman <nhorman@tuxdriver.com> wrote:

> I wrote this quirk awhile ago to properly setup MCP55 chips on hypertransport
> busses so that interrupts reached whatever cpu happend to boot the kdump kernel.
> while that works well, it was recently shown to me that a a non-hypertransport
> variant of the MCP55 exists, and on those system the register that this quirk
> manipulates causes hangs if you write to it.  Since the quirk was only meant to
> handle errors found on MCP55 chips that have a HT interface, this patch adds a
> filter to make sure the chip is an HT capable before making the needed register
> adjustment.  This lets the broken MCP55s work with kdump while not breaking the
> non-HT variants.
> 
> Resolves https://bugzilla.kernel.org/show_bug.cgi?id=23952
> 
> Tested successfully by the reporter and myself.
> 
> Reported-by: Mathieu B__rard <mathieu@mberard.eu>
> CC: linux-pci@vger.kernel.org
> CC: kexec@lists.infradead.org
> CC: Vivek Goyal <vgoyal@redhat.com>
> CC: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

That needed a Cc:<stable@kernel.org> as well.  Please don't forget to
remember -stable.
