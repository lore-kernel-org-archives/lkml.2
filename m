Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab0ERPmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 11:42:14 -0400
Received: from p01c11o144.mxlogic.net ([208.65.144.67]:49034 "EHLO
	p01c11o144.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755785Ab0ERPmM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 11:42:12 -0400
X-MXL-Hash: 4bf2b55318686839-f5be0f550e71ddb988a35bf770f3bcb8885dc175
X-MXL-Hash: 4bf2b54637e15a3c-f819c2573f784eb1fc9c407bbba1b2c99d21bd3f
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Jens Axboe <jens.axboe@oracle.com>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 18 May 2010 10:37:05 -0500
Subject: RE: linux-next: manual merge of the block tree with the vfs tree
Thread-Topic: linux-next: manual merge of the block tree with the vfs tree
Thread-Index: Acr2NsdDnHoHYQMVQiSd9hQB1D5seQAaQVsg
Message-ID: <0D753D10438DA54287A00B0270842697636F14E7ED@AUSP01VMBX24.collaborationhost.net>
References: <20100518130401.f6286112.sfr@canb.auug.org.au>
In-Reply-To: <20100518130401.f6286112.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010051701)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.98]
X-AnalysisOut: [v=1.0 c=1 a=bt2LUhtRutsA:10 a=yQWWgrYGNuUA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=kj9zAlcOel0A:10 a=IRTT+DMug47mVLgYdXzmDg==:17 a=rO]
X-AnalysisOut: [UgymgbAAAA:8 a=yqm-4A620hTCGODKAY4A:9 a=ppQdmHUttUQbiga10Q]
X-AnalysisOut: [ZjqkxoSVQA:4 a=CjuIK1q_8ugA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 17, 2010 8:04 PM, Stephen Rothwell wrote:
> Hi Jens,
>
> Today's linux-next merge of the block tree got a conflict in
> fs/fs-writeback.c between commit 1c9539ad0dd1c3c3964ea35d5a355a0ed19c39c7
> ("fs-writeback.c: bitfields should be unsigned") from the vfs tree and
> commit e913fc825dc685a444cb4c1d0f9d32f372f59861 ("writeback: fix
> WB_SYNC_NONE writeback from umount") from the block tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc fs/fs-writeback.c
> index 24e85ce,0f62957..0000000
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@@ -42,9 -42,10 +42,10 @@@ struct wb_writeback_args 
>   	long nr_pages;
>   	struct super_block *sb;
>   	enum writeback_sync_modes sync_mode;
>  -	int for_kupdate:1;
>  -	int range_cyclic:1;
>  -	int for_background:1;
>  -	int sb_pinned:1;
>  +	unsigned int for_kupdate:1;
>  +	unsigned int range_cyclic:1;
>  +	unsigned int for_background:1;
> ++	unsigned int sb_pinned:1;
>   };
>   
>   /*

Stephen,

Your fix looks good to me.

Regards,
Hartley