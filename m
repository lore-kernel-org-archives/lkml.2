Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914Ab1DKN5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 09:57:12 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42695 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1DKN5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 09:57:11 -0400
X-Sasl-enc: FZ2Xy6ggQAfP0s0whGn1WYpIhpGMVLzOSmz9NqIWpVaO 1302530230
Date: Mon, 11 Apr 2011 10:57:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/amd-iommu: Add support for invalidate_all
 command
Message-ID: <20110411135708.GB28056@khazad-dum.debian.net>
References: <1302514324-14717-1-git-send-email-joerg.roedel@amd.com>
 <1302514324-14717-3-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302514324-14717-3-git-send-email-joerg.roedel@amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, Joerg Roedel wrote:
> This patch adds support for the invalidate_all command
> present in new versions of the AMD IOMMU.

...

>  #define CMD_COMPL_WAIT          0x01
>  #define CMD_INV_DEV_ENTRY       0x02
>  #define CMD_INV_IOMMU_PAGES     0x03
> +#define CMD_INV_ALL		0x08

...

> @@ -463,6 +463,12 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
>  		cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
>  }
>  
> +static void build_inv_all(struct iommu_cmd *cmd)
> +{
> +	memset(cmd, 0, sizeof(*cmd));
> +	CMD_SET_TYPE(cmd, CMD_INV_DEV_ENTRY);

Huh?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
