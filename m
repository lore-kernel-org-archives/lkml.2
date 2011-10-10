Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab1JJQNJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 12:13:09 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:45421 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab1JJQNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 12:13:08 -0400
X-IronPort-AV: E=Sophos;i="4.68,518,1312156800"; 
   d="scan'208";a="8308402"
Subject: Re: [Xen-devel] [PATCH 3/3] xen/blk[front|back]: Enhance discard
 support with secure erasing support.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        Jan Beulich <JBeulich@novell.com>, Li Dongyang <lidongyang@novell.com>
Date: Mon, 10 Oct 2011 17:13:07 +0100
In-Reply-To: <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
References: <1318260494-27985-1-git-send-email-konrad.wilk@oracle.com>
	 <1318260494-27985-4-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318263187.21903.464.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 16:28 +0100, Konrad Rzeszutek Wilk wrote:
> diff --git a/include/xen/interface/io/blkif.h b/include/xen/interface/io/blkif.h
> index 9324488..04f60b0 100644
> --- a/include/xen/interface/io/blkif.h
> +++ b/include/xen/interface/io/blkif.h
> @@ -84,6 +84,10 @@ typedef uint64_t blkif_sector_t;
>   *     e07154r6-Data_Set_Management_Proposal_for_ATA-ACS2.doc
>   * http://www.seagate.com/staticfiles/support/disc/manuals/
>   *     Interface%20manuals/100293068c.pdf
> + * We also provide three extra XenBus options to the discard operation:
> + * 'discard-granularity' - Max amount of sectors that can be discarded.
> + * 'discard-alignment' - 4K, 128K, etc aligment on sectors to erased.
> + * 'discard-secure' - whether the discard can also securely erase data.
>   */
>  #define BLKIF_OP_DISCARD           5
>  
> @@ -107,6 +111,7 @@ struct blkif_request_rw {
>  struct blkif_request_discard {
>         blkif_sector_t sector_number;
>         uint64_t nr_sectors;
> +       uint8_t secure:1;
>  };
>  
>  struct blkif_request { 

Which tree/branch is this? I don't see BLKIF_OP_DISCARD in mainline or
your linux-next branch.

Since this changes an inter-guest ABI we may need to consider backwards
compatibility (I suspect this interface is new enough that no one has
actually implemented it in anger and we can get away with changing it).
In any case it should also be posted against the canonical inter-guest
interface definition in the xen tree for review with that in mind.

I think an explicit flag variable is likely to be less trouble WRT
maintaining compatibility in the future than a bit-field. Also I think
you may as well align the struct size to something larger than a byte,
either 4 or 8 bytes would make sense.

Ian.

