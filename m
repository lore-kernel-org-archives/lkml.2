Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1LVIUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:20:55 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1LVIUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:20:53 -0500
Date: Thu, 22 Dec 2011 09:22:33 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Udo Steinberg <udo@hypervisor.org>
Cc: Keith Packard <keithp@keithp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: Re: GPU hung with Linux-3.2-rc6
Message-ID: <20111222080928.GA3904@phenom.ffwll.local>
Mail-Followup-To: Udo Steinberg <udo@hypervisor.org>,
	Keith Packard <keithp@keithp.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
References: <20111221195410.5e4c065a@x220.fritz.box>
 <864nwty9sq.fsf@sumi.keithp.com>
 <20111221222626.0b8c3a30@x220.fritz.box>
 <861urxy1pw.fsf@sumi.keithp.com>
 <20111222014520.7ace1ab2@x220.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222014520.7ace1ab2@x220.fritz.box>
X-Operating-System: Linux phenom 3.1.0-1-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 01:45:20AM +0100, Udo Steinberg wrote:
> On Wed, 21 Dec 2011 14:55:07 -0800 Keith Packard (KP) wrote:
> 
> KP> On Wed, 21 Dec 2011 22:26:26 +0100, Udo Steinberg <udo@hypervisor.org> wrote:
> KP> 
> KP> > That makes the problem go away. If you need more help tracking down the
> KP> > problem, then let me know. I can reproduce it fairly easily with something
> KP> > as simple as:
> KP> > 
> KP> > 	while true; do dmesg; done
> KP> 
> KP> Are you using SNA?
> 
> I don't think so. I'm using the following packages:
> 
> xorg-server-1.9.5
> xf86-video-intel-2.15.0
> libdrm-2.4.25
> mesa-7.10.2
> 
> I quick google search suggests that at least some of them are too old to
> support SNA.

Can you please apply the patch available at

http://cgit.freedesktop.org/~danvet/drm/patch/?id=0b3ecfa8c9b00f50d514fbcc12e34882b0fa695a

This one will let your gpu keep hanging in the "stuck on semphore wait"
condition. Later on the hangcheck should kick in and grab a gpu error
state (in the file i915_error_state in debugfs). Can you please attach
that one?

Thanks, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
