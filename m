Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab2GRJEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 05:04:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43470 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939Ab2GRJEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 05:04:01 -0400
Date: Wed, 18 Jul 2012 10:03:46 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 02/36] ipc: Add COMPAT_SHMLBA support
Message-ID: <20120718090345.GA25929@mudshark.cambridge.arm.com>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com>
 <1341608777-12982-3-git-send-email-catalin.marinas@arm.com>
 <50064F5E.108@jonmasters.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50064F5E.108@jonmasters.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 06:53:34AM +0100, Jon Masters wrote:
> On 07/06/2012 05:05 PM, Catalin Marinas wrote:
> 
> > The reason for this patch is that we want SHMLBA to be 64K on AArch64
> 
> Presumably this is to obviate differences between 64K or 4K pages?

Right, we don't have D-side aliasing with AArch64 processors, so SHMLBA can
be left as the minimum alignment requirement, which is PAGE_SIZE.

The compat bit is more fun because userspace expects to see 16k there.

Will
