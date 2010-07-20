Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab0GTPQB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:16:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41839 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932242Ab0GTPP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:15:59 -0400
Date: Tue, 20 Jul 2010 17:15:56 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Robert Love <robert.w.love@intel.com>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Vasu Dev <vasu.dev@intel.com>, Joe Eykholt <jeykholt@cisco.com>,
        devel@open-fcoe.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/16] trivial: use ARRAY_SIZE
In-Reply-To: <1277726113-24666-1-git-send-email-segooon@gmail.com>
Message-ID: <alpine.LNX.2.00.1007201715330.4741@pobox.suse.cz>
References: <1277726113-24666-1-git-send-email-segooon@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Kulikov Vasiliy wrote:

> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/scsi/libfc/fc_exch.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
> index 104e0fb..ca52bfa 100644
> --- a/drivers/scsi/libfc/fc_exch.c
> +++ b/drivers/scsi/libfc/fc_exch.c
> @@ -219,8 +219,6 @@ static void fc_exch_els_rrq(struct fc_seq *, struct fc_frame *);
>   */
>  static char *fc_exch_rctl_names[] = FC_RCTL_NAMES_INIT;
>  
> -#define FC_TABLE_SIZE(x)   (sizeof(x) / sizeof(x[0]))
> -
>  /**
>   * fc_exch_name_lookup() - Lookup name by opcode
>   * @op:	       Opcode to be looked up
> @@ -249,7 +247,7 @@ static inline const char *fc_exch_name_lookup(unsigned int op, char **table,
>  static const char *fc_exch_rctl_name(unsigned int op)
>  {
>  	return fc_exch_name_lookup(op, fc_exch_rctl_names,
> -				   FC_TABLE_SIZE(fc_exch_rctl_names));
> +				   ARRAY_SIZE(fc_exch_rctl_names));
>  }

Applied. Please use better Subject: lines next time though. Having the 
whole series have the same Subject: line doesn't really help.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
