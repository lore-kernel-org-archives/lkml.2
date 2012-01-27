Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2A0O27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:28:59 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:35522 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973Ab2A0O26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:28:58 -0500
Message-ID: <4F22B4A6.1070202@vmware.com>
Date: Fri, 27 Jan 2012 15:28:54 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jakob Bornecrantz <jakob@vmware.com>
CC: airlied@linux.ie, airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, joe Perches <joe@perches.com>,
        Ryan Mallon <rmallon@gmail.com>
Subject: Re: [RFC PATCH] vmwgfx: Fix assignment in vmw_framebuffer_create_handle
References: <1345211595.178155.1327674293610.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <1345211595.178155.1327674293610.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 03:24 PM, Jakob Bornecrantz wrote:
> I was asking around and this seems to only be used by X when it
> starts and we want to preserve the contents of the screen. That
> feature is implemented by the X driver. So we need to figure how we
> want to solve it.
>
> Either way this fix should probably go into this RC series, not
> sure if we need to send this to stable, since we are not leaking
> data to userspace (check drm_mode_getfb), but we might as well.
>
> Reviewed-by: Jakob Bornecrantz<jakob@vmware.com>

But shouldn't we return the *real* handle. Not 0??

/Thomas




>
> Cheers, Jakob.
>
> ----- Original Message -----
>> Ryan,
>>
>> Thanks for pointing this out. Unfortunately there  seems to be two
>> bugs here, the one you pointed out and the fact that we set the handle
>> to zero, when it probably should be set to struct
>> vmw_framebuffer::user_handle.
>>
>> Jakob, can you comment on this?
>>
>> /Thomas
>>
>> On 01/27/2012 07:25 AM, Ryan Mallon wrote:
>>> The assignment of handle in vmw_framebuffer_create_handle doesn't
>>> actually do anything useful and is incorrectly assigning an integer
>>> value to a pointer argument. It appears that this is a typo and
>>> should
>>> be dereferencing handle rather than assigning to it directly.
>>>
>>> Signed-off-by: Ryan Mallon<rmallon@gmail.com>
>>> ---
>>>
>>> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
>>> b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
>>> index 0af6ebd..b66ef0e 100644
>>> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
>>> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
>>> @@ -378,7 +378,7 @@ int vmw_framebuffer_create_handle(struct
>>> drm_framebuffer *fb,
>>>    				  unsigned int *handle)
>>>    {
>>>    	if (handle)
>>> -		handle = 0;
>>> +		*handle = 0;
>>>
>>>    	return 0;
>>>    }
>>>
>>

