Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab2A0OyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:54:15 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:35570 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589Ab2A0OyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:54:13 -0500
Message-ID: <4F22BA91.9020406@vmware.com>
Date: Fri, 27 Jan 2012 15:54:09 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Jakob Bornecrantz <jakob@vmware.com>
CC: airlied@linux.ie, airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, joe Perches <joe@perches.com>,
        Ryan Mallon <rmallon@gmail.com>
Subject: Re: [RFC PATCH] vmwgfx: Fix assignment in vmw_framebuffer_create_handle
References: <170320114.179239.1327675287439.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <170320114.179239.1327675287439.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2012 03:41 PM, Jakob Bornecrantz wrote:
> ----- Original Message -----
>> On 01/27/2012 03:24 PM, Jakob Bornecrantz wrote:
>>> I was asking around and this seems to only be used by X when it
>>> starts and we want to preserve the contents of the screen. That
>>> feature is implemented by the X driver. So we need to figure how we
>>> want to solve it.
>>>
>>> Either way this fix should probably go into this RC series, not
>>> sure if we need to send this to stable, since we are not leaking
>>> data to userspace (check drm_mode_getfb), but we might as well.
>>>
>>> Reviewed-by: Jakob Bornecrantz<jakob@vmware.com>
>> But shouldn't we return the *real* handle. Not 0??
> Yeah, you are right. Not sure we have user_handle in the stable
> kernels tho.
We do AFAICT.

>
> We need to change not only the X driver but also all the other
> userspace components since at least libkms doesn't create shared
> buffers.
Libkms is not used anymore, at least not in the X server driver.

>   And if the thing that is running before X is using fbdev
> this wont do much good either since fbdev is not backed by a
> fb in the way other drivers do it.
OK. Then I suggest we just return 0 here, and go ahead with the current 
patch, and
when we've figured out how to do the handover, we bump kernel minor and
return a proper handle. Does that sound OK?

/Thomas


>
> Cheers, Jakob.

