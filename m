Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab0ELNP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:15:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:44027 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0ELNP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=U8kksZl/rxfs0+so6JpGTaS5NZrp8LudhHzUTn/wPCaKF82D/pb++zoXvsNl3S3IKz
         rruuyADKYDre7qMp6/8PxxN/se/S0CYE9AqwLQbQfz4TdEaclO11/AsYsX5okd6DR9Wi
         B5CnGokJFYcnJopIMYKO9hfmjdmWWX4omfpqk=
MIME-Version: 1.0
In-Reply-To: <89khjo$fd2th6@orsmga002.jf.intel.com>
References: <0100511104818.8382a7de.akpm@linux-foundation.org>
	 <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk>
	 <AANLkTimglAyS94q0Y3DEx9RROPxus-7l3OfF2_b-zAR3@mail.gmail.com>
	 <AANLkTinmXAAq1HQTb_k3A-bl4uCz1ERhOIHNoCjqzEB4@mail.gmail.com>
	 <89khjo$fd2th6@orsmga002.jf.intel.com>
Date: Wed, 12 May 2010 18:45:55 +0530
Message-ID: <AANLkTilbqi5crUD8KXmZ5SIv92KioEAN7Ra6nk2ALU6F@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Record error batch buffers using iomem
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, dri-devel@lists.freedesktop.org,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris,

On Wed, May 12, 2010 at 1:23 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Wed, 12 May 2010 01:08:23 +0530, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>> Hello Chris and Andrew,
>>
>> I did further testing and noticed that this patch fixes the boot
>> errors and warnings and I get the XWindows.
>>
>> But XWindows freezes after some time.
>
> The BUG you were hitting before is on the error collection path which
> presumably is still being triggered during boot by a GPU error.
> Can you check to see if /sys/kernel/debug/dri/0/i915_error_state has
> recorded anything? And if not, wait until it freezes and then please file
> a bug report at bugs.freedesktop.org with the i915_error_state, Xorg.0.log
> and dmesg.
>

With this patch after XWindows freezes, I get :

[   70.433064] wlan0: no IPv6 routers present
[  227.490064] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
elapsed... GPU hung
[  227.490098] ------------[ cut here ]------------
[  227.490124] WARNING: at mm/highmem.c:453 debug_kmap_atomic+0xa9/0x11e()
[  227.490135] Hardware name: Aspire one
[  227.490143] Modules linked in: nf_conntrack_ftp ath9k ath9k_common
ath9k_hw battery [last unloaded: scsi_wait_scan]
[  227.490183] Pid: 0, comm: swapper Not tainted 2.6.34-rc7-netbook #8
[  227.490193] Call Trace:
[  227.490214]  [<c1030ecb>] warn_slowpath_common+0x65/0x7c

freeze dmesg : http://userweb.kernel.org/~jaswinder/acer_netbook/dmesg_2634_chris_hang.txt

freeze Xorg.log : http://userweb.kernel.org/~jaswinder/acer_netbook/Xorg_log.txt

So it means this patches shifted the BUG and warning messages after
some time. So I can only work on XWindows for few minutes with this
patch.
Andrew patch is in linus git tree. Can you please update your patch
above Andrew patch. So that I can do further testing.

Thanks,
--
Jaswinder Singh.
