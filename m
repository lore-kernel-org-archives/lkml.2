Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2A0OTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:19:07 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:53777 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab2A0OTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:19:06 -0500
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jan 2012 09:19:06 EST
Message-ID: <4F22B02F.2010502@vmware.com>
Date: Fri, 27 Jan 2012 15:09:51 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Ryan Mallon <rmallon@gmail.com>, jakob@vmware.com
CC: airlied@linux.ie, airlied@redhat.com, dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        joe Perches <joe@perches.com>
Subject: Re: [RFC PATCH] vmwgfx: Fix assignment in vmw_framebuffer_create_handle
References: <4F224348.8050607@gmail.com>
In-Reply-To: <4F224348.8050607@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryan,

Thanks for pointing this out. Unfortunately there  seems to be two bugs 
here, the one you pointed out and the fact that we set the handle to zero,
when it probably should be set to struct vmw_framebuffer::user_handle.

Jakob, can you comment on this?

/Thomas

On 01/27/2012 07:25 AM, Ryan Mallon wrote:
> The assignment of handle in vmw_framebuffer_create_handle doesn't
> actually do anything useful and is incorrectly assigning an integer
> value to a pointer argument. It appears that this is a typo and should
> be dereferencing handle rather than assigning to it directly.
>
> Signed-off-by: Ryan Mallon<rmallon@gmail.com>
> ---
>
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> index 0af6ebd..b66ef0e 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> @@ -378,7 +378,7 @@ int vmw_framebuffer_create_handle(struct drm_framebuffer *fb,
>   				  unsigned int *handle)
>   {
>   	if (handle)
> -		handle = 0;
> +		*handle = 0;
>
>   	return 0;
>   }
>

