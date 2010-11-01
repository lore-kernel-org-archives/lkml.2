Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab0KAWAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 18:00:19 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:46759 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751216Ab0KAWAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 18:00:16 -0400
Message-ID: <4CCF3863.9040500@shipmail.org>
Date: Mon, 01 Nov 2010 23:00:03 +0100
From: Thomas Hellstrom <thomas@shipmail.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100624 Mandriva/3.0.5-0.1mdv2009.1 (2009.1) Thunderbird/3.0.5
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 1/4] drivers/gpu/drm/vmwgfx: Fix k.alloc switched arguments
References: <cover.1288555098.git.joe@perches.com>	<1bb253bedd9345e3457ce699f9fbc6f65844738f.1288555098.git.joe@perches.com> <AANLkTinYZ=ZpkRiL2eMtcO_fAAFhBBCoT2fLH0tKaNn9@mail.gmail.com>
In-Reply-To: <AANLkTinYZ=ZpkRiL2eMtcO_fAAFhBBCoT2fLH0tKaNn9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 12:52 AM, Matt Turner wrote:
> On Sun, Oct 31, 2010 at 6:33 PM, Joe Perches<joe@perches.com>  wrote:
>    
>> Signed-off-by: Joe Perches<joe@perches.com>
>> ---
>>   drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c     |    2 +-
>>   drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c |    2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
>> index a01c47d..29113c9 100644
>> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
>> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c
>> @@ -557,7 +557,7 @@ int vmw_kms_init_legacy_display_system(struct vmw_private *dev_priv)
>>                 return -EINVAL;
>>         }
>>
>> -       dev_priv->ldu_priv = kmalloc(GFP_KERNEL, sizeof(*dev_priv->ldu_priv));
>> +       dev_priv->ldu_priv = kmalloc(sizeof(*dev_priv->ldu_priv), GFP_KERNEL);
>>
>>         if (!dev_priv->ldu_priv)
>>                 return -ENOMEM;
>> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
>> index df2036e..f1a52f9 100644
>> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
>> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
>> @@ -585,7 +585,7 @@ int vmw_overlay_init(struct vmw_private *dev_priv)
>>                 return -ENOSYS;
>>         }
>>
>> -       overlay = kmalloc(GFP_KERNEL, sizeof(*overlay));
>> +       overlay = kmalloc(sizeof(*overlay), GFP_KERNEL);
>>         if (!overlay)
>>                 return -ENOMEM;
>>
>> --
>> 1.7.3.1.g432b3.dirty
>>      
> Oh! That's a bad one.
>    
Indeed.

> Reviewed-by: Matt Turner<mattst88@gmail.com>
>    
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>

> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>    

