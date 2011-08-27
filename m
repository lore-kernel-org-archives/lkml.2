Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab1H0CuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 22:50:12 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61918 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1H0CuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 22:50:07 -0400
Subject: Re: [PATCH] virtio: fix size computation according to the
 definition of struct vring_used in vring_size
From: Wanlong Gao <wanlong.gao@gmail.com>
Reply-To: wanlong.gao@gmail.com
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <4E584365.1010806@gmail.com>
References: <4E584365.1010806@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: FNST
Date: Sat, 27 Aug 2011 10:49:59 +0800
Message-ID: <1314413399.1913.1.camel@Allen>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-27 at 09:07 +0800, Wang Sheng-Hui wrote:
> The patch is against 3.1-rc3.
> 
> struct vring_used has two __u16 fields plus array of struct vring_used_elem.
> Current vring_size counts the __u16 fields to 3. Fix it to 2 in the patch.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  include/linux/virtio_ring.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
> index 4a32cb6..fcda152 100644
> --- a/include/linux/virtio_ring.h
> +++ b/include/linux/virtio_ring.h
> @@ -143,7 +143,7 @@ static inline unsigned vring_size(unsigned int num, unsigned long align)
>  {
>  	return ((sizeof(struct vring_desc) * num + sizeof(__u16) * (2 + num)
>  		 + align - 1) & ~(align - 1))
> -		+ sizeof(__u16) * 3 + sizeof(struct vring_used_elem) * num;
> +		+ sizeof(__u16) * 2 + sizeof(struct vring_used_elem) * num;
>  }
>  
>  /* The following is used with USED_EVENT_IDX and AVAIL_EVENT_IDX */

Hi:
I'm not deep into it, but I think you can see this:
http://marc.info/?l=git-commits-head&m=130687915816130&w=2

Thanks
-Wanlong Gao

