Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab0G2B05 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 21:26:57 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47702 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0G2B04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 21:26:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Y1b56rcy1+VXIAxKfwEFZJlWfOv/Ke8kfoK14VabRE4XTv5+07aVtT0l8F1WKUb+dH
         xlG036t+GfkLCLWPAW+hnKrgjmxRotnZBasLQnI6sRQ0gIsw2NtwxzzCcU6UcX4UprZh
         t0STVQ541mNLTkAUjTBlFevFvhPoCN6jBhO2U=
MIME-Version: 1.0
In-Reply-To: <20100729111904.90b148a6.sfr@canb.auug.org.au>
References: <20100729111904.90b148a6.sfr@canb.auug.org.au>
Date: Wed, 28 Jul 2010 18:26:54 -0700
X-Google-Sender-Auth: CW9a0RIm3QVeL7UHNiWT_iYe634
Message-ID: <AANLkTimFauHpzYk4C3sW=o-k+9yJP0iz1kWKXE9Brnzn@mail.gmail.com>
Subject: Re: linux-next: manual merge of the net tree with the net-current 
	tree
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bruce Allan <bruce.w.allan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 18:19, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the net tree got a conflict in
> drivers/net/e1000e/hw.h between commit
> ff847ac2d3e90edd94674c28bade25ae1e6a2e49 ("") from the net-current tree
> and commit d3738bb8203acf8552c3ec8b3447133fc0938ddd ("e1000e: initial
> support for 82579 LOMs") from the net tree.
>
> Just context changes. I fixed it up (see below) and can carry the fix for
> a while.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/net/e1000e/hw.h
> index 664ed58,0cd569a..0000000
> --- a/drivers/net/e1000e/hw.h
> +++ b/drivers/net/e1000e/hw.h
> @@@ -308,8 -312,8 +312,8 @@@ enum e1e_registers
>  #define E1000_KMRNCTRLSTA_INBAND_PARAM        0x9    /* Kumeran InBand Parameters */
>  #define E1000_KMRNCTRLSTA_DIAG_NELPBK 0x1000 /* Nearend Loopback mode */
>  #define E1000_KMRNCTRLSTA_K1_CONFIG   0x7
>  -#define E1000_KMRNCTRLSTA_K1_ENABLE   0x140E
>  +#define E1000_KMRNCTRLSTA_K1_ENABLE   0x0002
> - #define E1000_KMRNCTRLSTA_K1_DISABLE  0x1400
> + #define E1000_KMRNCTRLSTA_HD_CTRL     0x0002
>
>  #define IFE_PHY_EXTENDED_STATUS_CONTROL       0x10
>  #define IFE_PHY_SPECIAL_CONTROL               0x11 /* 100BaseTx PHY Special Control */
> --

yes, that is fine and expected.  When Dave sync's up is net-next-2.6
tree with net-2.6 tree, this issue will be fixed up.

-- 
Cheers,
Jeff
