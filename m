Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0GBAnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 20:43:04 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45455 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab0GBAnA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 20:43:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aFFlXcY75fz0ntH52Jv1OJeIFS6P9YYOUiOsWCsqJHLqXkPA08ysP3AK2XkTbA/cCt
         /x2jHRu1zlpIvve1DGg+oePUZxV10tylHJmjuI259FAxPYGtuRQs3BQrjEIB0jjZ4Ikl
         CmnTb2e0acJnoDEbZw9PTX9y50UyJh+5cQIz4=
MIME-Version: 1.0
In-Reply-To: <AANLkTinvzJrx4AqgWYuMg66Djf-snouLQZE7wI9Bu0Kv@mail.gmail.com>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
	<AANLkTimgH-DiQyg0f-an5FS3Wyb2b6He3fxxB1L8Ziol@mail.gmail.com>
	<1278024678.7738.54.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTinNrpcBg0TXTS78qaI5kPQKD-IbnLpDStu4_BIg@mail.gmail.com>
	<1278026975.7738.89.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTilGdNgWIprJ2XZ2gSv2d-DVybGmb9phcboi4fNL@mail.gmail.com>
	<1278029284.7738.116.camel@c-dwalke-linux.qualcomm.com>
	<AANLkTilEKPmHKNDNbNpmUvcYC338YezLkNBc4ShfTFdp@mail.gmail.com>
	<4C2D3066.9040104@codeaurora.org>
	<AANLkTilsqmCZwLUNJhvDKkralHQZzlRV3ZxaIGbt9-xB@mail.gmail.com>
	<AANLkTinvzJrx4AqgWYuMg66Djf-snouLQZE7wI9Bu0Kv@mail.gmail.com>
Date: Thu, 1 Jul 2010 20:42:59 -0400
Message-ID: <AANLkTimiNKRabIDCLvRwxVfdwuvt76PbDuTn2RocZLVG@mail.gmail.com>
Subject: Re: Closed source userspace graphics drivers with an open source 
	kernel component
From: Timothy Meade <zt.tmzt@gmail.com>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>,
       linux-arm-msm@vger.kernel.org, jcrouse@codeaurora.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---------- Forwarded message ----------
From: Timothy Meade <zt.tmzt@gmail.com>
Date: Thu, Jul 1, 2010 at 8:38 PM
Subject: Closed source userspace graphics drivers with an open source
kernel component
To: Saravana Kannan <skannan@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel
<dri-devel@lists.freedesktop.org>, linux-arm-msm@vger.kernel.org,
jcrouse@codeaurora.org



On Thu, Jul 1, 2010 at 8:18 PM, Saravana Kannan <skannan@codeaurora.org> wrote:
>
> Dave Airlie wrote:
>>
>> This is more about initial development stages. We maintain kernel
>> API/ABI for all in-tree drivers, however before we put a driver into
>> mainline, we usually need to redo the crazy interfaces that vendors
>> have come up with. Like 32/64 alignment, passing userspace addresses
>> into the kernel, passing phy addresses to userspace etc. If the
>> userspace binary is closed that process becomes next to impossible.
>
> My 2 cents:
> I think we should leave the onus of fixing the userspace to work with the sane kernel API with the entity trying to get their drivers into the kernel. I think it's a better approach (as in, more likelihood of getting device support) than saying, we will only allow fully open sourced kernel drivers.
>
> -Saravana
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Hello.  I've been working with the developers on the htc-linux project
and following the progress of Android on MSM devices closely for a few
years.  I've been excitied to see DRM/DRI replace PMEM and the Android
specific interfaces be replaced with more Linux-like ones.  The Xorg
driver from Qualcomm uses this same interface for 2D and it's possible
that Android will take the same approach, though it uses 3D and GLES
as a type of abstraction layer for surfaceflinger.  This allows for a
closed 3D driver with an open command submission layer that is in
itself not that different from the split for ATI devices using
radeonhd.  I say this because the alternative for these devices is a
fully closed binary and secrecy surrounding the graphics layers that
ensures that only the OS that ships with the device can ever really be
used and preventing those non-coorporate developers as myself from
utilising GPL code the way we want or even usuing are own cell phones
(in this case).  I would choose a fully open, X based OS even if that
meant only having 2D drivers, but I know that Quic and others aren't
going to develop just a (accelerated) 2D driver, not the kernel
components or userspace but instead rely on the same GLES layer that
Android uses, essentially making X and open environments a second
class citizen on modern mobile hardware.

I hope those making the decision will take this into consideration.

--
Timothy Meade (tmzt on freenode)
