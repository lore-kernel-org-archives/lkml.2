Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1BIJmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:42:12 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:45641 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab1BIJmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:42:10 -0500
Message-ID: <88546787bbe2f26026d6f291fdadef52.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTikWdpvDCf=tGry1WrJx9SrOjdSnEw75DSihcg0h@mail.gmail.com>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
    <s5hfws1whq8.wl%tiwai@suse.de>
    <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
    <AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
    <AANLkTinYnehdaXn=Om-hVdo_U9N47BWFTgFoJbjpzuo=@mail.gmail.com>
    <d41841c1e5f524f976edea8cdd075238.squirrel@webmail.greenhost.nl>
    <AANLkTikWdpvDCf=tGry1WrJx9SrOjdSnEw75DSihcg0h@mail.gmail.com>
Date: Wed, 9 Feb 2011 10:42:05 +0100 (CET)
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: "Indan Zupancic" <indan@nul.nu>
To: "Jeff Chua" <jeff.chua.linux@gmail.com>
Cc: "Chris Wilson" <chris@chris-wilson.co.uk>, "Takashi Iwai" <tiwai@suse.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "Len Brown" <lenb@kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 2ecd0b53b7de9511489f92806276a3d7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, February 9, 2011 06:45, Jeff Chua wrote:
>
> This may help a little. I added printk("intel_crtc 2") inside
> intel_crtc_reset() and added printk("intel_crtc 1") before calling
> intel_crtc_reset().
>
> Looking at  dmesg, it looks like something else is calling
> intel_crtc_reset() and not from intel_crtc_init() during resume.

That something else is the drm layer.

(I must say it's very unclear what the the ordering of driver function
calls will be from just looking at drm the code. I hope the drm
abstraction is working out well for others, to me it all seems a bit
awkward. If state needs to be tracked, fine, but do it either in the
drm layer or let the driver handle it.)

> intel_crtc 2 ffff880239cdf000
> intel_crtc 2 ffff880239cdf800

This doesn't really help, all it probably means is that you've got
multiple crtc outputs, or something like that. It might help if you
get two calls with the offending commit, but only one without it.

I'd add printk's to the *_crtc_disable()/*_crtc_enable() calls with
info whether it actually enables or disables something and compare
the result between a working suspend and a broken one.

Greetings,

Indan


