Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2K0Fr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 00:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab2K0Fr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 00:47:56 -0500
Message-ID: <50B45406.40603@redhat.com>
Date: Tue, 27 Nov 2012 13:47:50 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: fix length for cross region descriptor
References: <20121126155727.GA21716@redhat.com>
In-Reply-To: <20121126155727.GA21716@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2012 11:57 PM, Michael S. Tsirkin wrote:
> If a single descriptor crosses a region, the
> second chunk length should be decremented
> by size translated so far, instead it includes
> the full descriptor length.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>   drivers/vhost/vhost.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index ef8f598..5a3d0f1 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1049,7 +1049,7 @@ static int translate_desc(struct vhost_dev *dev, u64 addr, u32 len,
>   		}
>   		_iov = iov + ret;
>   		size = reg->memory_size - addr + reg->guest_phys_addr;
> -		_iov->iov_len = min((u64)len, size);
> +		_iov->iov_len = min((u64)len - s, size);
>   		_iov->iov_base = (void __user *)(unsigned long)
>   			(reg->userspace_addr + addr - reg->guest_phys_addr);
>   		s += size;

Acked-by: Jason Wang <jasowang@redhat.com>
