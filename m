Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759823Ab1IITOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 15:14:20 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8496 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759534Ab1IITOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 15:14:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6464"; a="117157167"
Date: Fri, 9 Sep 2011 14:14:13 -0500
From: "Linas Vepstas (Code Aurora)" <linas@codeaurora.org>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v3 24/36] Hexagon: Provide basic implementation and/or
 stubs for I/O routines.
Message-ID: <20110909191412.GB2034@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org>
 <20110909010916.993872033@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909010916.993872033@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 08:09:11PM -0500, Richard Kuo wrote:
> +	asm volatile(
> +		"memb(%0) = %1;"
> +		:
> +		: "r" (addr), "r" (data)
> +	);

I'm kind-of vague on this, but I think that this also needs a
: "memory" at the end (to indicate that the asm snippet clobbers
memory), as otherwise the compiler may be tempted to reorder
these around other memory accesses. That is, the "volatile"
keyword is not enough (well, I'm not sure...), but I think
"volatile" only prevents the compiler from optimizing these
away completely, but is not enough to prevent unwanted
re-ordering.

--linas

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
