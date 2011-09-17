Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1IQSPz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 14:15:55 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59599 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752026Ab1IQSPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 14:15:54 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19zNxZkl99zN64F+TcouKdZJPO0iOWMXkTq5u3NjD
	H+FALNpsaguvr9
Message-ID: <4E74E3D6.8080401@gmx.de>
Date: Sat, 17 Sep 2011 18:15:50 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: Rob Clark <rob@ti.com>, Felipe Contreras <felipe.contreras@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: Proposal for a low-level Linux display framework
References: <1316088425.11294.78.camel@lappyti>	<yunboul7sx7.fsf@aiko.keithp.com>	<1316100594.23214.65.camel@deskari>	<yun8vpp7qk7.fsf@aiko.keithp.com>	<4E72320B.6020000@gmx.de>	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>	<4E724659.5080709@gmx.de>	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>	<CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com>	<CAF6AEGu2-O+2KuCrQPJ6-xejg8TCScrFVZSimgkAV_5Xs-bgkg@mail.gmail.com>	<4E74C6C3.2000704@gmx.de> <CAPM=9twmPVrBPmUuEuTYHSzjDGHtfsmiVX6cozpAFYEaV-NcCg@mail.gmail.com>
In-Reply-To: <CAPM=9twmPVrBPmUuEuTYHSzjDGHtfsmiVX6cozpAFYEaV-NcCg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2011 04:47 PM, Dave Airlie wrote:
>>
>> I disagree. This depends on the functionality the hardware has, the desired
>> userspace and the manpower one has to do it. And of course if you just want fb
>> having fb via DRM/KMS has some overhead/bloat. It's perfectly okay to have just
>> an fb driver for devices that can't do more anyway.
>> And fb is no legacy interface but actively developed, just with other goals than
>> DRM/KMS is, it aims for stability and to provide a direct interface, not needing
>> any X or wayland crap.
> 
> Stability is a total misnomer, whats worse is you know it. If you just
> want to do software render your whole GUI whether you use KMS or fbdev
> doesn't matter. Instability is only to do with GPU hardware
> acceleration, whether fb or kms expose accel doesn't matter. So less
> attitude please.

Is it? Well, okay, I don't want to use any acceleration that can crash my
machine, where can I select it, preferably as compile time option? I didn't find
such a thing for Intel or Radeon. Don't say, I should rely on userspace here or
use fbdev for this.
The thing is that the core fbdev API does not expose any acceleration to
userspace, maybe some drivers do via IOCTLs, but I hope that are only things
that can be done in a sane way, otherwise I'd consider it a bug. The story is
different for DRM/KMS, as I understand, as this was primarily for acceleration
and only recently got modesetting capabilities.

> fbdev is totally uninteresting for any modern multi-output hardware
> with an acceleration engine, you can't even memory manage the GPU
> memory in any useful way, try resizing the fb console dynamically when
> you've allocated the memory immediately following it in VRAM, you
> can't as userspace has it direct mapped, with no way to remove the
> mappings or repage them. Even now I'm still thinking we should do
> kmscon without exposing the fbdev interface to userspace because the
> whole mmap semantics are totally broken, look at the recent fb
> handover race fixes.

It's true that mmap can be PITA, but I don't see any real alternative given that
you want directly map video memory, especially on low end systems. And there are
ways around it, you can forbid mapping (though probably most userspace wouldn't
like it, I guess) or use any other solution like defio.
If you'd stop exposing the fbdev userspace interface it'd just harden my opinion
that KMS is a piece of trash and that I should avoid hardware that does not have
a native framebuffer driver. I think you shouldn't do this, as it's just a
disadvantage for your end users, but I personally do not really care.


Regards,

Florian Tobias Schandinat
