Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072Ab0LNVLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:11:37 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:34595 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540Ab0LNVLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:11:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=daQPyv6S9KEbkXsA0De/C5tmHkoK0JFs8poOYbRBxFrMg8lwIuiOX1H8EJO4iQyX0E
         rEFN8AVD8+WInYfXXdlK/D6JUm4pn+EZp7bDp0h4MvxXdZ7Jxh0FrAHIq7Wjf0FRPP85
         wsoNacW8bWaYv+mfhinsCTsQkeGePI/IOvbjY=
MIME-Version: 1.0
In-Reply-To: <AANLkTimNeDCH4jvP1QM785oNdua+GzwmtUA+OKzmO5aX@mail.gmail.com>
References: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
	<1292332047-8206-5-git-send-email-fernando.lugo@ti.com>
	<AANLkTin0eBk1tMDUJQQ6KuM6eOu1gu+JmwY-Nz0V+jw8@mail.gmail.com>
	<AANLkTimNeDCH4jvP1QM785oNdua+GzwmtUA+OKzmO5aX@mail.gmail.com>
Date: Tue, 14 Dec 2010 23:11:33 +0200
Message-ID: <AANLkTin6CBc3gBCHbD8XdQ7E3mQdEkO+rn6Y=u-tv2m0@mail.gmail.com>
Subject: Re: [PATCHv6 4/4] omap: iommu - create new api to set valid da range
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
Cc: Hiroshi.DOYU@nokia.com, linux@arm.linux.org.uk, h-kanigeri2@ti.com,
        felipe.contreras@nokia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, "Guzman Lugo, Fernando" <x0095840@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 8:59 PM, Guzman Lugo, Fernando
<fernando.lugo@ti.com> wrote:
> On Tue, Dec 14, 2010 at 9:08 AM, Felipe Contreras
> <felipe.contreras@gmail.com> wrote:
>> On Tue, Dec 14, 2010 at 3:07 PM, Fernando Guzman Lugo
>> <fernando.lugo@ti.com> wrote:
>>> From: Guzman Lugo, Fernando <x0095840@ti.com>
>>>
>>> Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF rage.
>>> With this new API the valid range can be set.
>>>
>>> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
>>> Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
>>
>> I still don't see where this API is being used.
>
> you can find it here:
>
> http://marc.info/?l=linux-kernel&m=128805403014740&w=2

Oh, ok, thanks. somehow I missed it.

>> Also, the point of using platform data was to add it to omap3_devices
>> in omap-iommu.c, see[1]. I thought the platform data start/end would
>> move to struct iommu, and iommu_set_da_range would change the
>> start/end on struct iommu, but that would only be necessary if the
>> platform data doesn't match that.
>
> it is not clear for me. do you mean having default start/end in
> platform data then when iommu_get is call pass them to start/end in
> struct iommu and the new api change start/end in struct iommu?
>
> Please let me know if that is correct.

Yeah, if you are not going to add it in the platform data
(mach-omap2/omap-iommu.c), then it doesn't make sense to use platform
data for that.

Cheers.

-- 
Felipe Contreras
