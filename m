Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab1FGW4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 18:56:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:21388 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab1FGW4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 18:56:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,335,1304319600"; 
   d="scan'208";a="10410157"
From: "Rose, Gregory V" <gregory.v.rose@intel.com>
To: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Andi Kleen <ak@linux.intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Date: Tue, 7 Jun 2011 15:56:34 -0700
Subject: RE: [PATCH 4/5] ixgbe: Fix incorrect declaration of ixgbevf_mbx_ops
Thread-Topic: [PATCH 4/5] ixgbe: Fix incorrect declaration of ixgbevf_mbx_ops
Thread-Index: AcwlYh7EkTtJKb7JTfGoOJOCVlOzdgAA6Z7Q
Message-ID: <43F901BD926A4E43B106BF17856F0755018E536956@orsmsx508.amr.corp.intel.com>
References: <1307485593-27196-1-git-send-email-andi@firstfloor.org>
 <1307485593-27196-4-git-send-email-andi@firstfloor.org>
In-Reply-To: <1307485593-27196-4-git-send-email-andi@firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Tuesday, June 07, 2011 3:27 PM
> To: linux-kernel@vger.kernel.org
> Cc: Andi Kleen; Kirsher, Jeffrey T; Brandeburg, Jesse; Rose, Gregory V
> Subject: [PATCH 4/5] ixgbe: Fix incorrect declaration of ixgbevf_mbx_ops
> 
> From: Andi Kleen <ak@linux.intel.com>
> 
> The header extern type of ixgbevf_mbx_ops disagreed with
> the actual declaration. Fix this here.
> 
> This is rather scary. I haven't tested it. Did this
> ever work?
> 
> Cc: jeffrey.t.kirsher@intel.com
> Cc: jesse.brandeburg@intel.com
> Cc: gregory.v.rose@intel.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  drivers/net/ixgbevf/ixgbevf.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ixgbevf/ixgbevf.h b/drivers/net/ixgbevf/ixgbevf.h
> index b703f60..a2bbbb3 100644
> --- a/drivers/net/ixgbevf/ixgbevf.h
> +++ b/drivers/net/ixgbevf/ixgbevf.h
> @@ -279,7 +279,7 @@ enum ixgbevf_boards {
> 
>  extern struct ixgbevf_info ixgbevf_82599_vf_info;
>  extern struct ixgbevf_info ixgbevf_X540_vf_info;
> -extern struct ixgbe_mac_operations ixgbevf_mbx_ops;
> +extern struct ixgbe_mbx_operations ixgbevf_mbx_ops;
> 
>  /* needed by ethtool.c */
>  extern char ixgbevf_driver_name[];
> --
> 1.7.4.4

[Greg Rose] 
Huh.

Well, mbx ops is a table of 8 pointers and mac ops is a table of 11 pointers, so the copy would have over written 3 * pointer-size words of some other memory.  But the 8 ops copied would have been correct so to the extent that we called them they worked.

Now that I look at it you missed a another spot where the copy is done that uses the ixgbe_mac_operations instead of the ixgbe_mbx_operations.

I'll fix that up.

Nice catch!

- Greg
