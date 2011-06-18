Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab1FREke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 00:40:34 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3267 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab1FREkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 00:40:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=AnDPEdapX6HN8xgnYKsGiFVIvOoQHjZPMFJTShjs6uUQ2K/ChCUfeUsDTaZsZjsuoZ
         MDhES0i7U7547OoO77Ow==
Date: Fri, 17 Jun 2011 21:40:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Suppress spurious vblank interrupts
In-Reply-To: <AANLkTi=JD4zwo9aW7iQW-==dQM9W7NHyq12uOPBqGYSB@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1106172136290.21481@sister.anvils>
References: <849307$bc24ct@azsmga001.ch.intel.com> <1296471462-8578-1-git-send-email-chris@chris-wilson.co.uk> <alpine.LSU.2.00.1102010909270.1586@sister.anvils> <20110201094643.366bc073@jbarnes-desktop> <20110201100833.3219687e@jbarnes-desktop>
 <AANLkTim4kL9OjBDiQQ1MBfOCzThxmDonBic11N45NKxj@mail.gmail.com> <20110201113238.60b33ff9@jbarnes-desktop> <AANLkTikwfHd6t95-jhbXCy1ciW3OV+HVYVikZNs5LHfz@mail.gmail.com> <20110202091838.5efaa660@jbarnes-desktop> <alpine.LSU.2.00.1102081132160.1591@sister.anvils>
 <87E55E65-72FF-462C-8BD3-84C367021DB7@tuebingen.mpg.de> <AANLkTi=JD4zwo9aW7iQW-==dQM9W7NHyq12uOPBqGYSB@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-833175681-1308372025=:21481"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-833175681-1308372025=:21481
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 14 Feb 2011, Hugh Dickins wrote:
> On Fri, Feb 11, 2011 at 10:21 AM, Mario Kleiner
> <mario.kleiner@tuebingen.mpg.de> wrote:
> > On Feb 8, 2011, at 8:52 PM, Hugh Dickins wrote:
> >> =C2=A0It appears that the
> >> underruns, while mysterious and worrisome, have litte or nothing to do
> >> with the unflushed text problem which is making 2.6.38-rc unusable.
> >>
> I'm sorry to say that I have now given up on this: it has already
> consumed a lot more time than I can afford to give it.  So I've now
> just turned CONFIG_DRM_I915_KMS off, which gives me a laptop on which
> 2.6.38-rc is usable.
>=20
> If in due course there's a likely patch someone would like me to try,
> that I can do.  And from time to time, with new kernels and with
> upgraded userspace, I'll give I915_KMS a try again - indeed, for the
> moment I still have it in my 64bit kernel.
>=20
> Before switching KMS off, I did establish that, with Chris's overrun
> fix, do_intel_finish_page_flip() - the function whose call to
> do_gettimeofday() I moved - is no longer called at all.  So that
> modification was just cargo-cult magic by now (though perhaps made a
> difference to timings when overruns were happening), and there's no
> reason to suspect Mario's vblank patch at all.  Let's assume that if I
> attempted a fifth bisection, it would lead me to another (equally
> blameless) patch.  Nobody else is complaining: maybe my 965 is broken
> and just gets along better with 2.6.38 KMS off.

Just wanted to report that something (sorry, no time to work out what)
in 3.0-rc1 fixed this issue for me, so now I am back on I915_KMS: thanks.

Hugh
--8323584-833175681-1308372025=:21481--
