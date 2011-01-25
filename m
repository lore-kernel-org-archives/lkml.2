Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337Ab1AYGt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 01:49:58 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:34981 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab1AYGt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 01:49:57 -0500
Date: Tue, 25 Jan 2011 15:49:49 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Heiko Schocher <hs@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4 v5] powerpc, video: add SM501 support for charon board.
Message-ID: <20110125064949.GF11673@linux-sh.org>
References: <1291451028-22532-2-git-send-email-hs@denx.de> <1295937946-26934-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295937946-26934-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 07:45:46AM +0100, Heiko Schocher wrote:
> @@ -197,6 +198,15 @@
>  			#address-cells = <1>;
>  		};
>  
> +		display@1,0 {
> +			compatible = "smi,sm501";
> +			reg = <1 0x00000000 0x00800000
> +			       1 0x03e00000 0x00200000>;
> +			mode = "640x480-32@60";
> +			interrupts = <1 1 3>;
> +			little-endian;
> +		};
> +

The endian designation looks good, but it still doesn't explain why you
have a remaining CONFIG_PPC_MPC52xx ifdef encapsulating the property
check in the sm501fb patch. It shouldn't be needed at all. If the
platform supports OF then the property will need to be set one way or the
other, so there is no need for any board or CPU ifdeffery within the
driver itself.
