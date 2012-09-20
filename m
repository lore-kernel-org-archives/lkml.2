Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab2ITIpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 04:45:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:26382 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2ITIpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 04:45:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,453,1344236400"; 
   d="scan'208";a="224346961"
Date: Thu, 20 Sep 2012 16:45:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Vivek Trivedi <t.vivek@samsung.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Documentation: add description of
 dirty_background_centisecs
Message-ID: <20120920084507.GB5697@localhost>
References: <1347798364-2864-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347798364-2864-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ add CC ]

On Sun, Sep 16, 2012 at 08:26:04AM -0400, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> This commit adds dirty_background_centisecs description in bdi sysfs
> documentation.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Vivek Trivedi <t.vivek@samsung.com>
> ---
>  Documentation/ABI/testing/sysfs-class-bdi |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-bdi b/Documentation/ABI/testing/sysfs-class-bdi
> index 5f50097..6869736 100644
> --- a/Documentation/ABI/testing/sysfs-class-bdi
> +++ b/Documentation/ABI/testing/sysfs-class-bdi
> @@ -48,3 +48,28 @@ max_ratio (read-write)
>  	most of the write-back cache.  For example in case of an NFS
>  	mount that is prone to get stuck, or a FUSE mount which cannot
>  	be trusted to play fair.
> +
> +dirty_background_centisecs (read-write)
> +
> +	It is used to start early writeback of given bdi once bdi dirty
> +	data exceeds product of average write bandwidth and
> +	dirty_background_centisecs. It works in parallel of
> +	dirty_writeback_centsecs and dirty_expire_interval based periodic
> +	flushing mechanism.
> +
> +        It is mainly useful for tuning writeback speed at 'NFS Server'
> +	sothat NFS client could see better write speed.
> +	A good use case is setting it to around 100 (1 second) in the NFS
> +	server for improving NFS write performance. Note that it's not
> +	recommended to set it to a too small value, which might lead to
> +	unnecessary flushing for small IO size.
> +        Setting it to 0 disables the feature.
> +
> +	However, sometimes it may not match user expectations as it is based
> +	on bdi write bandwidth estimation. The users should not expect this
> +	threshold to work accurately.
> +	Write bandwidth estimation is a best effort to estimate bdi write
> +	speed bandwidth. But it can be wildly wrong in certain situations
> +	such as sudden change of workload (including the workload startup
> +	stage), or if there are no heavy writes since boot, in which case
> +	there is no reasonable estimation yet.
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
