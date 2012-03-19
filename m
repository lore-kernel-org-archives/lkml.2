Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759194Ab2CSPgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:36:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:55784 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759086Ab2CSPgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:36:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141260415"
Date: Mon, 19 Mar 2012 17:44:33 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linaro-mm-sig@lists.linaro.org, LKML <linux-kernel@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: document fd flags and O_CLOEXEC requirement
Message-ID: <20120319154433.GP4917@intel.com>
References: <CAPM=9twSZJyYcNwDwaC5eSy7fXNaRBGTZZ6F2K3D8AeQdYtgww@mail.gmail.com>
 <1332171715-1484-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1332171715-1484-1-git-send-email-daniel.vetter@ffwll.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 04:41:55PM +0100, Daniel Vetter wrote:
> Otherwise subsystems will get this wrong and end up with a second
> export ioctl with the flag and O_CLOEXEC support added.
> 
> v2: Fixup the function name and caution exporters to limit the flags
> to only O_CLOEXEC. Noted by Dave Airlie.
> 
> Cc: Dave Airlie <airlied@gmail.com>
> Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
>  Documentation/dma-buf-sharing.txt |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> index 9f3aeef..a6d4c37 100644
> --- a/Documentation/dma-buf-sharing.txt
> +++ b/Documentation/dma-buf-sharing.txt
> @@ -319,6 +319,12 @@ Miscellaneous notes
>  - Any exporters or users of the dma-buf buffer sharing framework must have
>    a 'select DMA_SHARED_BUFFER' in their respective Kconfigs.
>  
> +- To avoid the wrath of userspace library writers exporting subsystems must have
> +  a flag parameter in the ioctl that creates the dma-buf fd which needs to
> +  support at least the O_CLOEXEC fd flag. This needs to be passed in the flag
> +  parameter of dma_buf_fd. Without any other reasons applying it is recommended
> +  that exporters limit the flags passed to dma_buf_fd to only O_CLOEXEC.

Difficult to parse. Needs more punctuation.

-- 
Ville Syrjälä
Intel OTC
