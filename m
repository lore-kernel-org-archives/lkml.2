Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2HRVPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:15:55 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:63665 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2HRVPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:15:52 -0400
Date: Sat, 18 Aug 2012 23:15:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        James.Bottomley@HansenPartnership.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/31] Disable const sections for PA-RISC
Message-ID: <20120818211549.GA12298@merkur.ravnborg.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org> <1345311022-26328-2-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345311022-26328-2-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 10:29:52AM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The PA-RISC tool chain seems to have some problem with correct read/write
> attributes on sections. This causes problems when the const sections
> are fixed up for other architecture to only contain truly read-only
> data.
> 
> Disable const sections for PA-RISC
> 
> This can cause a bit of noise with modpost.
> 
> Cc: James.Bottomley@HansenPartnership.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/parisc/Kconfig  |    4 ++++
>  include/linux/init.h |   27 +++++++++++++++++++--------
>  2 files changed, 23 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
> index 3ff21b5..fbfeec9 100644
> --- a/arch/parisc/Kconfig
> +++ b/arch/parisc/Kconfig
> @@ -243,6 +243,10 @@ config NODES_SHIFT
>  	default "3"
>  	depends on NEED_MULTIPLE_NODES
>  
> +config BROKEN_RODATA
> +	bool
> +	default y

Could you please change this so we have a commonly defined HAVE_BROKEN_RODATA
symbol. Then arch's that have broken RO data can select this symbol.
If we experience tomorrow that sparc have the same issue then with
this patch sparc has to create a local definition of this symbol.

This allows you to add some comments of the usage of this symbol
in a common place too.

	Sam
