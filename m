Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab0FCIAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:00:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49960 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab0FCIAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:00:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KGtUMpWgtIAlfaiIF7wfPTw4NmAmM1lp2CC9krdT9c+oqURfsI8HQPo2Qrfk2wnDLF
         vo2RsF/AaaGxwrKrwzBMrAOOIJ1eKsdRqqhDh+S/24aHBwM25LmzOgDCfOf1Qk04go3K
         oUwnxdDqA6CbdAt+hAQoY9vfiK+0lqyNOJMSU=
MIME-Version: 1.0
In-Reply-To: <AANLkTilr92GkR8bfgyjtb8ToYEEAv4oCsFsfsy04HJRU@mail.gmail.com>
References: <20100603134753.710a64b3.sfr@canb.auug.org.au>
	<AANLkTilr92GkR8bfgyjtb8ToYEEAv4oCsFsfsy04HJRU@mail.gmail.com>
Date: Thu, 3 Jun 2010 16:00:09 +0800
Message-ID: <AANLkTim6v2s-Q5BndAKLOZKaA1wYgbU3UKJwNy-6Jkki@mail.gmail.com>
Subject: Re: linux-next: Tree for June 3
From: Dave Young <hidave.darkstar@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 3:39 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> On Thu, Jun 3, 2010 at 11:47 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi all,
>>
>> Changes since 20100602:
>>
>> My fixes tree contains:
>>      v4l-dvb: update gfp/slab.h includes
>>      arm: update gfp/slab.h includes
>>      davinci: update gfp/slab.h includes
>>      ocfs2: update gfp/slab.h includes
>>      acpi: update gfp/slab.h includes
>>
>> The sh tree lost its build failure.
>>
>> The rr tree lost its build failure.
>>
>> ----------------------------------------------------------------------------
>>
>> I have created today's linux-next tree at
>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>> (patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
>> are tracking the linux-next tree using git, you should not use "git pull"
>> to do so as that will try to merge the new linux-next release with the
>> old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
>> (see below).
>>
>
> Hi,
>
> With this build, I got weird module refcount:
>
> bash-3.1$ cat /proc/modules
> radeon 703776 4294967295 - Live 0xffffffffa017c000
> ttm 55891 0 radeon, Live 0xffffffffa0164000
> drm_kms_helper 25154 0 radeon, Live 0xffffffffa015b000
> drm 174333 2 radeon,ttm,drm_kms_helper, Live 0xffffffffa011f000
> fb 45136 1 radeon,drm_kms_helper, Live 0xffffffffa00ff000
> fbdev 861 0 fb, Live 0xffffffffa009e000
> i2c_algo_bit 4925 0 radeon, Live 0xffffffffa0069000
> cfbcopyarea 3229 0 radeon, Live 0xffffffffa0059000
> cfbimgblt 2138 0 radeon, Live 0xffffffffa002c000
> cfbfillrect 3241 0 radeon, Live 0xffffffffa0026000
> tun 13180 2 - Live 0xffffffffa0039000
> kvm_intel 42801 4294967295 - Live 0xffffffffa0112000
> kvm 250629 0 kvm_intel, Live 0xffffffffa00bf000
> dell_wmi 2939 4294967295 - Live 0xffffffffa000e000
> snd_hda_codec_analog 72342 0 - Live 0xffffffffa00ab000
> wmi 7636 0 dell_wmi, Live 0xffffffffa0004000
> e1000e 186408 4294967295 - Live 0xffffffffa006e000
> snd_hda_intel 22245 4294967295 - Live 0xffffffffa0061000
> snd_hda_codec 69600 1 snd_hda_codec_analog,snd_hda_intel, Live 0xffffffffa004600
> 0
> snd_hwdep 5914 0 snd_hda_codec, Live 0xffffffffa003e000
> 8139too 31275 4294967295 - Live 0xffffffffa002f000
> snd_pcm 70720 1 snd_hda_intel,snd_hda_codec, Live 0xffffffffa0012000
> snd_timer 18357 0 snd_pcm, Live 0xffffffffa0007000
> snd_page_alloc 7365 1 snd_hda_intel,snd_pcm, Live 0xffffffffa0000000
>
> As you can see, some refcount become negtive

Seems for some module drop reference of 0 in following code of init_module:

       /* Drop initial reference. */
        module_put(mod);

> --
> Regards
> dave
>



-- 
Regards
dave
