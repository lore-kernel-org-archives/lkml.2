Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0HKORe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:17:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39717 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab0HKORd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PextLPlfkIKRJJjxSkfdvX2JVpOJb1uXTzoPfMJfGKbGd7+HjNXUFdIh5eC6A21hQE
         VL/F/RioIAfyWLs0ymlaG24OMLtrROZAn7li+GcXpf0Oig64fYkalHXPnoISjCOAYWZ3
         LvatXTt/Rqzxlz0w/qk/V+L8scEQx0uZmcZHg=
MIME-Version: 1.0
In-Reply-To: <AANLkTimx0No2RgS8EdZCz=X8urJ8u4hVEVH5c1mcz_CW@mail.gmail.com>
References: <20100811084828.GA5709@nb-core2.darkstar.lan>
	<AANLkTimx0No2RgS8EdZCz=X8urJ8u4hVEVH5c1mcz_CW@mail.gmail.com>
Date: Wed, 11 Aug 2010 16:17:33 +0200
Message-ID: <AANLkTinDBjzOLXE8V3aaiYC=khKM5a8hzXMbNJpowkRt@mail.gmail.com>
Subject: Re: [DRM] BUG: sleeping function called from invalid context, 
	drm_lastclose
From: Luca Tettamanti <kronos.it@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 10:50 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Wed, Aug 11, 2010 at 6:48 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>> Hi Arnd,
>> this commit:
>>
>> commit 58374713c9dfb4d231f8c56cac089f6fbdedc2ec
>> Author: Arnd Bergmann <arnd@arndb.de>
>> Date:   Sat Jul 10 23:51:39 2010 +0200
>>
>>    drm: kill BKL from common code
>>
>>
>> moved the call to (inside drm_release) drm_lastclose inside dev->count_lock
>> spinlock.
>> drm_lastclose however takes dev->struct_mutex (now inside an atomic
>> context):
>
> I have a patch from Chris Wilson that I need to push to fix this,
> basically reducing the spin lock coverage,
> and relying on the global mutex to handle the open race.

Ok, thank you :)

Luca
