Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab1CXIEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:04:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34207 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933179Ab1CXIEY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=wR0FVWtt04v2f+6TbIiHb6gn39rqf4xeJHQE6+Ey1CJTFPezhM4VlY+9YM8Qfomne5
         5PIe1b7IEUF3Es+BMLhSDNWlTBg3jUuy61SiEJCiPj5CazHGJJDJDJYKibtU4WnyUfEx
         MZNZlFg3u2Z7uPsQrIbKFeu8rrx21h7+VZPeM=
MIME-Version: 1.0
In-Reply-To: <4D8A89E7.6060204@snapgear.com>
References: <1300768985-902-1-git-send-email-gerg@snapgear.com>
	<AANLkTimHzPn2Xe1RVRQKjwdynDvc3iL2=8kJ1p8kRZQ4@mail.gmail.com>
	<AANLkTi=ohXGdwfAtWmDJKCq+cJtFqJdTCmPCxFOg6dY6@mail.gmail.com>
	<4D8A89E7.6060204@snapgear.com>
Date: Thu, 24 Mar 2011 09:04:23 +0100
X-Google-Sender-Auth: NVQm-RkvD3dh_niQGBt0EZHGtDE
Message-ID: <AANLkTi=O76yY1NtiX5EVCA7=kGB6Tj1UsuXigKwZdKUk@mail.gmail.com>
Subject: Re: [PATCH 0/1] m68k: merge m68k and m68knommu arch directories
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: linux-m68k@vger.kernel.org, uclinux-dev@uclinux.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 01:01, Greg Ungerer <gerg@snapgear.com> wrote:
> Hi Geert,
>
> On 24/03/11 08:14, Geert Uytterhoeven wrote:
>>
>> On Wed, Mar 23, 2011 at 23:07, Geert Uytterhoeven<geert@linux-m68k.org>
>>  wrote:
>>>
>>> On Tue, Mar 22, 2011 at 05:43, Ã¡<gerg@snapgear.com>  wrote:
>>>>
>>>> The following patch merges the m68k and m68knommu arch directories.
>>>> This patch has been trimmed for review purposes - the automated file
>>>> moving and mergeing carried out by the script contained in this email
>>>> has been removed. Only the manually required changes after running the
>>>> script are shown as the patch. (So to end up with the final required
>>>> change you need to run this script then apply the patch).
>>>>
>>>> This change is available as the only commit on the m68knommu git tree,
>>>> for-linux branch:
>>>>
>>>> The following changes since commit
>>>> a952baa034ae7c2e4a66932005cbc7ebbccfe28d:
>>>> Ã¡Linus Torvalds (1):
>>>> Ã¡ Ã¡ Ã¡ Ã¡Merge branch 'for-linus' of
>>>> git://git.kernel.org/.../dtor/input
>>>>
>>>> are available in the git repository at:
>>>>
>>>> Ã¡git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git
>>>> for-linus
>>>>
>>>> Greg Ungerer (1):
>>>> Ã¡ Ã¡ Ã¡m68k: merge m68k and m68knommu arch directories
>>>>
>>>>
>>>> It is also on the for-next branch in that tree, so will get some testing
>>>> in the next tree for the next few days.
>>>
>>> defconfig is now a nommu-config, and it fails?
>>
>> BTW, haven't tried it myself yet. I'm busy bisecting an issue with
>> initrds, which
>> got introduced between 2.6.37 and 2.6.38.
>>
>> Init fails with "init: cannot open inittab", followed by
>> "Kernel panic - not syncing: Attempted to kill init!".
>>
>> As I can't get ramdisks to work on ARAnyM, I need to use real hardware,
>> which
>> suffers a lot from long reboot/copy kernel/test cycles...
>
> As one data point (though not sure how useful this is to you... :-)
> I can compile for an Atari target with the merge tree and load it
> and run it on ARAnyM - using a ramdisk for root fs. Seems to work
> ok.

Strange. On ARAnyM I get:

    Trying to unpack rootfs image as initramfs...
    rootfs image is not initramfs (junk in compressed archive); looks
like an initrd
    Freeing initrd memory: 350k freed

but later it fails with:

    RAMDISK: Couldn't find valid RAM disk image starting at 0.

It "works" (i.e. mounts) on the Amiga, but later it fails with the
inittab error.
Will  bisect more tonight...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
