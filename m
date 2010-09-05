Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab0IEKNf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 06:13:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41027 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0IEKNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 06:13:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CyKkSsEYXHshju1TLclaKi0xtll1wjstJJAnV59fvzxU2fs5oYz1/3Lrl9Z2+ayPoF
         1l/ygwfaxB35pNA101Lf2D+vFEAGRNyDIycKFs4FEWu23sTl81lQQJUYkuAxr4WTdQ+0
         9ZiepXAu+MzW3HhChtQ7Z8MUk1TKuetrB4MwA=
MIME-Version: 1.0
In-Reply-To: <20100905091451.GA23589@sucs.org>
References: <1283588234-2514-1-git-send-email-penberg@kernel.org>
	<89k83a$9hv9li@azsmga001.ch.intel.com>
	<AANLkTi=_OW5NvnS1oWzt3DW9CPPwNX_sAkPh_QOuXzhv@mail.gmail.com>
	<alpine.LSU.2.00.1009041244440.3044@sister.anvils>
	<87vd6ls0jd.fsf@turtle.gmx.de>
	<20100904224453.GA31664@sucs.org>
	<AANLkTin63=Eyyk_dwmKtPvP_qPyKR2eDn-2FmmvGjTQu@mail.gmail.com>
	<20100905091451.GA23589@sucs.org>
Date: Sun, 5 Sep 2010 12:13:33 +0200
Message-ID: <AANLkTi=rcFZff22TMX+vfQj=5jQunmiC2UvEhZoheeTd@mail.gmail.com>
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

On Sun, Sep 5, 2010 at 11:14 AM, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> On Sun, Sep 05, 2010 at 10:26:25AM +0200, Fabio Comolli wrote:
>>
>> Well, this is very strange. I also own an EeePC 900 (i915 of course)
>> and I don't have this problem at all, nor I need the patch. Actually I
>> run a plain 2.6.36-rc3 and it works perfectly.
>>
>> I use the latest userspace available, with xorg 1.9 and Intel video
>> driver v. 2.12 (Archlinux testing repositories).
>>
>> Which kernel / userspace are you using?
>
> OK that's interesting - are you seeing correct xrandr output after a
> suspend and resume too?

Yes:

[root@ratbert] - [~] xrandr
Screen 0: minimum 320 x 200, current 1024 x 600, maximum 4096 x 4096
LVDS1 connected 1024x600+0+0 (normal left inverted right x axis y
axis) 0mm x 0mm
   1024x600       59.5*+
   800x600        85.1     72.2     75.0     60.3     56.2
   640x480        85.0     72.8     75.0     59.9
   720x400        85.0
   640x400        85.1
   640x350        85.1
VGA1 disconnected (normal left inverted right x axis y axis)
TV1 disconnected (normal left inverted right x axis y axis)

(just resumed from suspend-to-ram - no hibernation configured)

> I previously said that everything was working
> perfectly a few weeks ago (only correct inputs were reported, only one
> FIFO message in dmesg, no tearing on video, no cursor disappearing,
> screen size was correct when X started, running xrandr doesn't make the
> screen flash white etc) and added my tested-by line only to find out
> that there were cases where phantom inputs were still being reported (
> http://marc.info/?l=linux-kernel&m=128272404206696&w=2 ).
>
> I'm using a 2.6.36-rc3 kernel (with the patch). I think userspace X is
> less relevant as I can reproduce the false VGA detection without X
> starting please see http://bugs.freedesktop.org/show_bug.cgi?id=29857
> for more details).  I've tested the 2.12 intel drivers which you can add
> via xorg-edgers (which I think was 1.8 but I'd have to check) and the
> 2.9 drivers which ship with Ubuntu 10.04 (which is xorg 1.7.6). The
> newer X userspace pieces show a nice speedup in things like desktop
> effects and textured video but if X doesn't run and inputs are being
> mis-detected then I don't think it is the root of the problem...
>
> I'm interested to know if it is just me seeing this issue. Did you even
> have a problem with 2.6.36-rc2? Do you have any debugging options (e.g.
> lock dep checking) on that would slow your kernel down and stop the
> issue from ocurring?
>

Never had this kind of issues. I also tested rc2 without problems.

> --
> Sitsofe | http://sucs.org/~sits/
>

Regards,
Fabio
