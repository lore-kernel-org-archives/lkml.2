Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965981Ab0CPDFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 23:05:35 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:54814 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965807Ab0CPDFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 23:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pHcuJahpsrt4g+B5L4rUoAnv3sQiIwzf0YKY15axoURo10gGCkl4JicS3t5ODM/OJA
         455e31y6ya81GOHjtt9vWlru7W0Cnxm19yU+83VMdLvPj+M+X5yQtHMckB247eWDjsg4
         nHFUVUjXxCyvVTUxuw5SMtlSUK1fnRR7pLiTM=
MIME-Version: 1.0
In-Reply-To: <4B9E76B8.2000208@codeaurora.org>
References: <4B8BE42C.1090401@codeaurora.org> <4B8BE489.7020402@codeaurora.org>
	 <21d7e9971003141756l51d9e971x83b8b8cfbb0de25@mail.gmail.com>
	 <4B9E76B8.2000208@codeaurora.org>
Date: Tue, 16 Mar 2010 13:05:32 +1000
Message-ID: <21d7e9971003152005j4245ca6dh82462d650cce2bff@mail.gmail.com>
Subject: Re: [PATCH] drm: Allow platform devices to register as DRM devices
From: Dave Airlie <airlied@gmail.com>
To: Jordan Crouse <jcrouse@codeaurora.org>
Cc: dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> I guess technically we could also drop the AGP requirement, but since it
> worked
> on my box with AGP=n it seemed to me like a NOP.

Its not a NOP, otherwise we'd remove it, AGP || AGP=n means if
AGP is enabled DRM must be enabled similiarly, it stops AGP=m + DRM=y
basically.

>>>  EXPORT_SYMBOL(drm_init);
>>> diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
>>> index ab6c973..48a14a0 100644
>>> --- a/drivers/gpu/drm/drm_edid.c
>>> +++ b/drivers/gpu/drm/drm_edid.c
>>> @@ -1220,6 +1220,9 @@ struct edid *drm_get_edid(struct drm_connector
>>> *connector,
>>>       int ret;
>>>       struct edid *edid;
>>>
>>> +       if (drm_core_check_feature(connector->dev,
>>> DRIVER_USE_PLATFORM_DEVICE))
>>> +               return NULL;
>>> +
>>
>>
>> This makes no sense, having the ability to probe EDID or not is most
>> definitely not a platform vs PCI problem.
>
> Yeah, that was my poor man's "Don't probe EDID" hack.  I'm not sure if there
> is a smart way to implicitly check to see if EDID should be probed, but I'm
> worried about abusing the features flag too badly, though if a
> DRIVER_USE_EDID
> is needed then we shouldn't be shy about using it.

The generic code never calls this only the driver, so there should be no
need for flags at all.

>> Not 100% sure about this, but if you only intend on KMS and don't need to
>> inform userspace of irq support this should be okay.
>
> Again, a "don't do this" hack.  I'll look at this more carefully and see if
> there
> is a good way to evaluate this based on the hooks that the platform has
> defined.

Its mostly used in UMS to inform userspace for some strange reason
its pretty legacy at this point, new driver should probably not hit it.

>>> @@ -60,7 +60,7 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct

>>
>> This also doesn't address noueau/vmwgfx entry points.
>
> Yep, thats my bad.  I'll refresh and push better patches without whitespace
> stupidity.

Thanks,
Dave.
