Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab0IEI03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 04:26:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50934 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab0IEI01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 04:26:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gajgBKcx3Iz4XC13aq3EEPRDXKBzGUSmT7xm/u11PSGuEZmmnLNzG4wQvMvDP31m8H
         f3tnKMnDSlrSle16Wa5Q1TnAMNVTLOx4kgr09779mXwLQy40Hqn3RBbRlrTcAg/cphNY
         CoV93jFNl3H6QXdMN+1fl/sb/McUTRVX19Efo=
MIME-Version: 1.0
In-Reply-To: <20100904224453.GA31664@sucs.org>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
	<89k83a$9hv9li@azsmga001.ch.intel.com>
	<AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
	<alpine.LSU.2.00.1009041244440.3044@sister.anvils>
	<87vd6ls0jd.fsf@turtle.gmx.de>
	<20100904224453.GA31664@sucs.org>
Date: Sun, 5 Sep 2010 10:26:25 +0200
Message-ID: <AANLkTin63=Eyyk_dwmKtPvP_qPyKR2eDn-2FmmvGjTQu@mail.gmail.com>
Subject: Re: [PATCH] Revert "drm/i915: fix vblank wait test condition"
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Sven Joachim <svenjoac@gmx.de>, Hugh Dickins <hughd@google.com>,
        Pekka Enberg <penberg@kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, Sep 5, 2010 at 12:44 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Sat, Sep 04, 2010 at 10:42:46PM +0200, Sven Joachim wrote:
>> On 2010-09-04 21:54 +0200, Hugh Dickins wrote:
>>
>> > On Sat, 4 Sep 2010, Pekka Enberg wrote:
>> >> On Sat,  4 Sep 2010 11:17:14 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>> >> >> This reverts commit 9559fcdbff4f93d29af04478bbc48294519424f5. The commit causes
>> >> >> wrong screen resolution on some i915 machines such as MacBook which is a
>> >> >> regression from 2.6.35. The issue has been reported multiple times but no fix
>> >> >> has emerged:
>> >>
>> >> On Sat, Sep 4, 2010 at 12:21 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> >> > NAK. You can't simply hide one bug by introducing a much bigger one.
>> >>
>> >> Dude, it's a nasty regression from 2.6.35. What exactly are you NAK'ing here?
>> >>
>> >> > As you have an affected machine, find which wait_for_vblank() needs to be
>> >> > replaced with a msleep(20|50).
>> >>
>> >> The attached patch fixes things here. I'm not a drm developer so I
>> >> don't know if it makes technical sense.
>> >
>> > Many thanks to you, Pekka: I also don't know if it makes technical sense,
>> > but it solves the same issue for me, so I can at last use 2.6.36-rc on
>> > this laptop.
>>
>> Helps for me as well, but I cannot judge whether it makes technical
>> sense either.  Thanks, Pekka!
>
> Sadly this doesn't help my EeePC 900 with an i915 when it is booted with
> a battery inside or after doing a suspend to ram (running
> modetest/xrandr in these situations says VGA is connected when there
> isn't even a cable attached).

Well, this is very strange. I also own an EeePC 900 (i915 of course)
and I don't have this problem at all, nor I need the patch. Actually I
run a plain 2.6.36-rc3 and it works perfectly.

I use the latest userspace available, with xorg 1.9 and Intel video
driver v. 2.12 (Archlinux testing repositories).

Which kernel / userspace are you using?

>
> --
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Regards,
Fabio
