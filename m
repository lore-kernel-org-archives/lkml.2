Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2GIPl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 11:41:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:34376 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2GIPl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 11:41:26 -0400
X-IronPort-AV: E=Sophos;i="4.77,552,1336363200"; 
   d="scan'208";a="30854307"
Message-ID: <4FFAFBA4.4050603@citrix.com>
Date: Mon, 9 Jul 2012 16:41:24 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/4] xen/p2m: Optimize the get_phys_to_machine
 function a bit.
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com> <1341330038-21686-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1341330038-21686-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/12 16:40, Konrad Rzeszutek Wilk wrote:
> Running perf tells me that the check for p2m_identity
> is done a lot - more than it should.

This patch doesn't change the how often the check is done.  Is this just
bad wording of the description?
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/p2m.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 64effdc..161bcdc 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -406,7 +406,7 @@ unsigned long get_phys_to_machine(unsigned long pfn)
>  	 * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
>  	 * would be wrong.
>  	 */
> -	if (p2m_top[topidx][mididx] == p2m_identity)
> +	if (unlikely(p2m_top[topidx][mididx] == p2m_identity))
>  		return IDENTITY_FRAME(pfn);
>  
>  	return p2m_top[topidx][mididx][idx];

