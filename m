Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0KXBTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 20:19:23 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55004 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0KXBTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 20:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QMEh9DzRtf7ZwGFsTgIHLcBO0U6doHN8B+/HNC8Z4cCfPeescLtlAfMpHsx1DfdEcm
         2yDEbeiNkADz8VC13FHhMas7XxEQ1axaH4DaRlQXeNY/lZKJx+HCXnvHBACugu/WAPaI
         QNdHKNf1mu79Bo/vx7D6WZR87TKyHHH0Ls3Kk=
MIME-Version: 1.0
In-Reply-To: <201011240157.00726.rjw@sisk.pl>
References: <201011240122.33174.rjw@sisk.pl>
	<201011240157.00726.rjw@sisk.pl>
Date: Tue, 23 Nov 2010 20:19:19 -0500
Message-ID: <AANLkTinRvXC9qDi9rkg1OeQ9FXrBwVJU0Y=9bUwrv8T4@mail.gmail.com>
Subject: Re: [Regression, post-2.6.37-rc2] Unable to start KDE with 2.6.37-rc3
 on Acer Ferrari One
From: Alex Deucher <alexdeucher@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/23 Rafael J. Wysocki <rjw@sisk.pl>:
> On Wednesday, November 24, 2010, Rafael J. Wysocki wrote:
>> Hi,
>>
>> I cannot start KDE with the 2.6.37-rc3 kernel.  The X server and display
>> manager start normally, but when I attempt to log into KDE, it attempts to
>> start, but then the X apparently crashes and this appears in the dmesg output:
>>
>> [   24.342287] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
>> [   24.342298] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
>> [   24.342304] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
>> [   24.694106] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>> [   93.938946] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
>> [   93.938956] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
>> [   93.938962] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
>> [   94.278050] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>> [  114.898043] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
>> [  114.898053] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
>> [  114.898058] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
>> [  115.266113] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>> [  129.722472] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>> [  142.984314] radeon 0000:01:05.0: r600_cs_track_validate_cb offset[0] 0 46097920 4325376 too big
>> [  142.984324] radeon 0000:01:05.0: r600_packet3_check:1331 invalid cmd stream 502
>> [  142.984330] [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
>> [  143.370083] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id
>>
>> This doesn't happen with 2.6.37-rc2.
>
> Reverting the following commit:
>
> commit 16790569eddf4d406a16a65f4750f405fa669c52
> Author: Alex Deucher <alexdeucher@gmail.com>
> Date:   Sun Nov 14 20:24:35 2010 -0500
>
>    drm/radeon/kms: fix and unify tiled buffer alignment checking for r6xx/7xx
>
> fixes the issue for me (so everyone involved is already in the Cc list ;-)).
>

Are you sure you've got the right commit?  That shouldn't change the
calculation that's failing at all.  I'd guess it's probably one of
these:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d33ef52d9db8a36900dd53f2e32db9a521ace259
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f30df2fad0c901e74ac9a52a488a54c69a373a41

Can you attach your xorg log as well?

Alex

> Thanks,
> Rafael
>
