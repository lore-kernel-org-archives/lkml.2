Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1HBV3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 17:29:48 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53546 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755383Ab1HBV3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 17:29:43 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX18cMh8WqGAcwv/uCflSeFfAzztboU6O8cyF1WXv/J
	eNkw0+HfOaZ5if
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Matthew Garrett <mjg@redhat.com>
Subject: Re: drm: Add a driver for kvm emulated Cirrus
Date: Tue, 2 Aug 2011 23:29:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.0-0.slh.5-aptosid-686; KDE/4.6.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1303157094-11425-1-git-send-email-mjg@redhat.com>
In-Reply-To: <1303157094-11425-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108022329.33538.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tuesday 02 August 2011, Matthew Garrett wrote:
> qemu-kvm emulates a Cirrus GPU, including its acceleration engine. We
> typically then run a Cirrus-specific X driver on top of this, which
> turns requests into commands and sends them to the emulated accelerator.
> This all seems to be unnecessary overhead given that we're just going
> to end up writing to memory from the host instead, and performance is
> almost certainly going to be better using an unaccelerated framebuffer
> and a guest-side shadow.
> 
> This patch provides a simple modesetting-only KMS driver for the hardware
> emulated in qemu-kvm. It's stripped down to the point where it's able to
> program the emulation, but would almost certainly fail miserably if asked
> to run on real hardware. It's intended to reduce virt overhead slightly,
> but also to serve as a template to writing a basic KMS driver.
> 
> The code and structure are heavily derived from Matt Turner's glint
> driver, with the modesetting code cribbed from cirrusfb (hence the
> license).
[...]

What is the status of this KMS based drm driver for cirrus-kvm?
I've been successfully testing this patch in 2.6.{38,39} and 3.0 
(Debian unstable userspace, xserver-xorg-core <=2:1.10.2.902-1, 
xserver-xorg-video-cirrus <=1:1.3.2-4+b1, qemu-kvm <=0.14.1+dfsg-4) 
with pretty good results. While it shares the same issues with plain 
cirrus (no regressions) before this patch (inverted colors in KDE, 
window management issues in LXDE), the KMS based drm driver seems to 
be a big improvement over all.

Regards
	Stefan Lippers-Hollmann
