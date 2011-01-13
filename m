Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab1AMUoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 15:44:05 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59826 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab1AMUn7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 15:43:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FXIkuhrgyGsAj87P9xzLKYvuTJzhb6ZuL8uB5Z7tiLYuHL69jvXkhypb1FgZL51ER2
         ubv62GE4fbxKxjDM/E38bhRcO0bRZ8LjAYj3SKdC1QKdUWcigGHvq0pntHvbwlO2vcVT
         x25pO3jizASltqdWyEX0mZ/njxqh4NzIzYAfI=
MIME-Version: 1.0
In-Reply-To: <1bdc18$j8l825@fmsmga002.fm.intel.com>
References: <AANLkTinBnm+xkXPPM4-3PG_i2hJMuXhv8x42KN4o3kGg@mail.gmail.com>
	<1294916869-2417-1-git-send-email-chris@chris-wilson.co.uk>
	<AANLkTimypim707rEXaPBaKoGgGmz3Of4EmPNw7VokJL6@mail.gmail.com>
	<1bdc18$j8l825@fmsmga002.fm.intel.com>
Date: Thu, 13 Jan 2011 21:43:57 +0100
Message-ID: <AANLkTikj7YGn34zVPo5Epv5c-OKsU=PmjskzpL43m5yy@mail.gmail.com>
Subject: Re: [PATCH] drm/i915/execbuffer: Clear domains before beginning reloc processing
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 5:10 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, 13 Jan 2011 07:54:59 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> On Thu, Jan 13, 2011 at 3:07 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > After reordering the sequence of relocating objects, commit 6fe4f1404,
>> > we can no longer rely on seeing all reloc targets prior to performing
>> > the relocation. So we need to clear the relocation domains earlier.
>>
>> Yup, this one (together with the previous fix) seems to get rid of all
>> the artifacts.

Just to add that this patch also fixes my gnome top and bottom panels
 on F14 where mouseover on the icons caused them to disappear and
 reappear, partly or entirely; in detail,

 2.6.37-git7 => ok
 2.6.37-git8 => ok
 2.6.37-git9 => bad (mouseover on panels has icons disappearing/reappearing)
 2.6.37-git9 + patch => ok

>> Should I just apply them as patches, or do you have a git branch to pull from?
>
> They will be in drm-intel-fixes. There have been a couple of other patches,
> for the compiler warning, the typo that Indan spotted and for modparam to
> workaround the U160, so I'll send the pull request it via Dave.
> -Chris
>
> $ git shortlog linus..upstream/drm-intel-fixes
> Chris Wilson (5):
>      drm/i915/debugfs: Correct format after changing type of err object 'size'
>      drm/i915: Add a module option to override the use of SSC
>      drm/i915: Fix error handler to capture the first batch after the seqno
>      drm/i915/execbuffer: Reorder relocations to match new object order
>      drm/i915/execbuffer: Clear domains before beginning reloc processing
>
> Indan Zupancic (1):
>      drm/i915/panel: The backlight is enabled if the current value is non-zero
>
> --
> Chris Wilson, Intel Open Source Technology Centre
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
