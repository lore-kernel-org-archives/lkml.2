Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab1F1VSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 17:18:46 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:39269 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750921Ab1F1VSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 17:18:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=pJANl61CTGAs9NotGK6TbrnrwGZy5l/0e4dAAmjNCa0C3k9GNrbALBRskKM6Vll6QZ4jhOt03yoG4v/IFKDIb/h/6NFLegIQZH8yxnESsdA6/rfS8BDOv/tjYxRXBchs;
Date: Tue, 28 Jun 2011 14:18:31 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olaf Freyer <aaron667@gmx.net>
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org
Subject: Re: Erroneous package power limit notification since kernel 2.6.39
Message-ID: <20110628141831.55502d76@jbarnes-desktop>
In-Reply-To: <4E0A4319.6040309@gmx.net>
References: <4DD9092A.4080507@gmx.net>
	<loom.20110525T172412-101@post.gmane.org>
	<20110626182725.3f2eac8d@schatten.dmk.lab>
	<4E0A3DB1.8000202@gmx.net>
	<20110628135936.297293b4@jbarnes-desktop>
	<4E0A4319.6040309@gmx.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jun 2011 23:09:45 +0200
Olaf Freyer <aaron667@gmx.net> wrote:
> >>> I'd guess ccab5c82759e2ace74b2e84f82d1e0eedd932571 could be the
> >>> cause. Can you check if the appended revert of that commit makes
> >>> things disappear? 
> >> It seems like you guessed perfectly correct - reverting the commit makes
> >> those notifications go away at once.
> >>
> > Without this reverted you see messages?  I missed the earlier stuff,
> > what message are you seeing?
> >
> Since 2.6.39 I saw those as soon as I start up the xserver:
> 
> May 22 14:41:34 localhost kernel: [   57.525844] CPU4: Package power
> limit notification (total events = 1)
> May 22 14:41:34 localhost kernel: [   57.525848] CPU0: Package power
> limit notification (total events = 1)
> May 22 14:41:34 localhost kernel: [   57.525851] CPU1: Package power
> limit notification (total events = 1)
> May 22 14:41:34 localhost kernel: [   57.525854] CPU2: Package power
> limit notification (total events = 1)
> May 22 14:41:34 localhost kernel: [   57.525856] CPU5: Package power
> limit notification (total events = 1)
> May 22 14:41:34 localhost kernel: [   57.525859] CPU3: Package power
> limit notification (total events = 1)
> May 22 14:41:34 localhost kernel: [   57.525861] Disabling lock
> debugging due to kernel taint
> May 22 14:41:34 localhost kernel: [   57.525869] CPU6: Package power
> limit notification (total events = 1)
> May 22 14:41:34 localhost kernel: [   57.525872] CPU7: Package power
> limit notification (total events = 1)
> May 22 14:41:34 localhost kernel: [   57.536890] CPU1: Package power
> limit normal
> May 22 14:41:34 localhost kernel: [   57.536893] CPU4: Package power
> limit normal
> May 22 14:41:34 localhost kernel: [   57.536896] CPU2: Package power
> limit normal
> May 22 14:41:34 localhost kernel: [   57.536899] CPU3: Package power
> limit normal
> May 22 14:41:34 localhost kernel: [   57.536901] CPU5: Package power
> limit normal
> May 22 14:41:34 localhost kernel: [   57.536904] CPU0: Package power
> limit normal
> May 22 14:41:34 localhost kernel: [   57.536915] CPU6: Package power
> limit normal
> May 22 14:41:34 localhost kernel: [   57.536918] CPU7: Package power
> limit normal

Ok interesting, didn't realize X startup was so GPU intensive. :)

The patch you reverted will definitely cause the GPU to ramp up its
frequency much faster than before, but it sounds like on your system
you might also see it with the revert if you run something GPU
intensive like nexuiz.

The CPU (and by extension the GPU) will take care of itself though; if
things get too hot or over power, it will clock throttle to keep itself
in a safe range.

-- 
Jesse Barnes, Intel Open Source Technology Center
