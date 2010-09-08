Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab0IHQKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 12:10:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:44608 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086Ab0IHQKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 12:10:14 -0400
Message-ID: <4C87B547.5080700@kernel.org>
Date: Wed, 08 Sep 2010 18:09:43 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100825 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Christoph Hellwig <hch@lst.de>, jack@suse.cz, mst@redhat.com,
        linux-ide@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        James.Bottomley@suse.de, konishi.ryusuke@lab.ntt.co.jp,
        k-ueda@ct.jp.nec.com, vst@vlnb.net, linux-scsi@vger.kernel.org,
        rusty@rustcorp.com.au, linux-raid@vger.kernel.org, mpatocka@redhat.com,
        swhiteho@redhat.com, chris.mason@oracle.com, tytso@mit.edu,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rwheeler@redhat.com,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 42/41 v2] dm: convey that all flushes are processed as
 empty
References: <1283509796-1510-1-git-send-email-tj@kernel.org> <1283509796-1510-24-git-send-email-tj@kernel.org> <4C84CD18.6060906@redhat.com> <20100907211724.GA22525@redhat.com> <20100907221543.GB22525@redhat.com> <20100907234918.GA23921@redhat.com> <20100908000001.GA21552@lst.de> <20100908020429.GA24635@redhat.com>
In-Reply-To: <20100908020429.GA24635@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Sep 2010 16:09:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2010 04:04 AM, Mike Snitzer wrote:
> Rename __clone_and_map_flush to __clone_and_map_empty_flush for added
> clarity.
> 
> Simplify logic associated with REQ_FLUSH conditionals.
> 
> Introduce a BUG_ON() and add a few more helpful comments to the code
> so that it is clear that all flushes are empty.
> 
> Cleanup __split_and_process_bio() so that an empty flush isn't processed
> by a 'sector_count' focused while loop.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c |   34 +++++++++++++++-------------------
>  1 files changed, 15 insertions(+), 19 deletions(-)
> 
> Tejun, please feel free to fold this patch into (or insert after)
> 0025-dm-relax-ordering-of-bio-based-flush-implementation.patch

I added it after 26 and updated flush-fua branch accordingly.

Thank you.

-- 
tejun
