Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0IMVUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:20:07 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:36776 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751399Ab0IMVUG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:20:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Gvppfqs8OZzLV21cSdez4vJDJtScwg2fluMjmKefpQ0OGkHwkjPQeM2EU4HCQpf+A7318SzkxsYViCvdPiOdiD3/XTBnDMqYMJVM/ujrYsdHnZvfGn73lHYG3wzCIoHj;
Date: Mon, 13 Sep 2010 14:19:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: intel-gfx@lists.freedesktop.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Interrupt latency on some 945GM platforms
Message-ID: <20100913141955.752cbdea@jbarnes-desktop>
In-Reply-To: <201009140010.14783.anarsoul@gmail.com>
References: <201009132336.17310.anarsoul@gmail.com>
	<20100913134441.762001f7@jbarnes-desktop>
	<201009140010.14783.anarsoul@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010 00:10:08 +0300
Vasily Khoruzhick <anarsoul@gmail.com> wrote:

> В сообщении от 13 of September 2010 23:44:41 автор Jesse Barnes написал:
> > I remember seeing a similar problem on an Eee PC I had; it seemed to be
> > timer/interrupt related somehow.  If I booted with clocksource=tsc
> > (or maybe it was pit) I got nice smooth animations, but if I used the
> > HPET things were really slow.
> > 
> > Does the same work for you?
> 
> Yeah, it works for me (will use it as temporary workaround). But it definitely 
> is not clean solution, as I can't use nohz mode with tsc clocksource :)

Thomas, does this ring any bells for you?

I think the root symptom of the issue is that we get a much reduced i915
interrupt frequency (or no interrupts) on some 945GM platforms when
using HPET as our clock source.

In fact, on the platform I tested, it seemed that the i915 IRQs wouldn't
generate interrupts at all when HPET was used.  But shaking the mouse or
generating network traffic was enough to get i915 interrupts coming in,
even though neither of those interrupts were shared with the i915
device.

Here's hoping you have some ideas to try...

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
