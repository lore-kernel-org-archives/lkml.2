Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab2BCSzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 13:55:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53839 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889Ab2BCSzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 13:55:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/4] pinctrl: add a driver for NVIDIA Tegra
Date: Fri, 3 Feb 2012 18:55:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        ext Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        linux-tegra@vger.kernel.org, Dong Aisheng <dong.aisheng@linaro.org>
References: <1328130290-17607-1-git-send-email-swarren@nvidia.com> <201202021533.14650.arnd@arndb.de> <CACRpkdbMPrvN80cLyVLUNvTjx4ZV4iLeHcJaJyM_qvTHHAfWww@mail.gmail.com>
In-Reply-To: <CACRpkdbMPrvN80cLyVLUNvTjx4ZV4iLeHcJaJyM_qvTHHAfWww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202031855.20589.arnd@arndb.de>
X-Provags-ID: V02:K0:6xFBUdoTdIlhkwBej2iVLRadPsFmW4Z7a3/3Gnp284u
 9ZEDCJ9h4WSDjy9LEFfTEWGeBpAgLjx/rTPlTEWsE6vLIeKYwa
 1TQ+YznyWuvdKD6xdgV6lpGNOXAzLpsIqX5rZDm/XqN4sgHqM7
 pf601n3ZJ3op3xB6eTiATMDD5myLbhQLM3O9kTtM3633ApBIv6
 2A8eL5uqkez6mqcMdv4/zOS4N4mCt5nynv7LOZE/r0KVt1Iv6Q
 YOgXaDNzflDP5tbETWi5mw7YxqciLelTppLK4RMCgOc9kSOOi2
 gOdNaBl2b+sVlt1/P5WYZNVWXrXiPwkT/wIDmnmDZXhtmWDyf6
 oJXhdadr4f1mMBVMeJXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 February 2012, Linus Walleij wrote:
> On Thu, Feb 2, 2012 at 4:33 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > [Me]
> >> Olof, Arnd: please verify that this is a direction you accept for the Tegra.
> >> (Olof has already ACK:ed it, mainly thinking about Arnd.)
> >
> > I would have liked to see a smaller pinctrl driver and one with fewer macros,
> > but I'm not going to complain about it -- drivers/pinctrl is definitely your
> > turf not mine and I assume that Olof's Ack was meant in his position as Tegra
> > maintainer instead of his position as arm-soc maintainer.
> 
> Which means I have no ACK from any of the ARM SoC maintainers
> on this which is touching the ARM tree substantially and affecting
> more or less all recent ARM SoCs,
> 
> Which is actually bad enough for me to have second thoughts on
> this.
>
> So I'm taking this branch off from -next until we resolve this.

That is the opposite of what I intended :(

I really meant that you don't need my Ack: the Tegra changes got an
Ack from the subarch maintainers and the drivers/pinctrl changes are
for you to judge. I don't have the resources to look into every patch
with the level of detail required to make a final decision, I really
have to rely on someone I trust like you to decide if something goes
in or not. Of course I can offer an opinion when you ask me, which
I did, but also didn't feel I understand the patch well enough to
ack them -- even though it looks reasonable to me.

Regarding the process, you have my full Ack on the plan to merge
them into mainline through your tree when you find them good enough
and also put a copy into the arm-soc tree if needed to resolve
any dependencies or conflicts with other stuff in arm-soc.
 
> > It's unfortunate that the number of lines in the board specific pinmux
> > files is actually growing, even though the contents seem to be smaller
> > and it seems to be done in a way that all the data will move into the
> > device tree eventually. What is holding up that move right now?
> 
> This is being held up by the discussion in the thread:
> "Pinmux bindings proposal V2" and its precursor.
> 
> Evidently it is hard to reach consensus on DT bindings, my
> analysis is that this is because these tend to turn into full-blown
> hardware-description committe work rather than Linux kernel
> issues. (This is both good and bad.)
> 
> There will be no pinmux DT bindings until there is a patch for
> it that gets an ACK from the majority of interested parties,
> preferably all.

Ok, I see.

> > I guess if we could move the per-board pinmux data into dts files,
> > that would mean we could actually get rid of the per-board source
> > files in tegra, right?
> 
> If you mean these:
> 
>  arch/arm/mach-tegra/board-harmony-pinmux.c        |  362 ++-
>  arch/arm/mach-tegra/board-paz00-pinmux.c          |  362 ++-
>  arch/arm/mach-tegra/board-pinmux.c                |   62 +-
>  arch/arm/mach-tegra/board-pinmux.h                |   39 +-
>  arch/arm/mach-tegra/board-seaboard-pinmux.c       |  442 ++-
>  arch/arm/mach-tegra/board-trimslice-pinmux.c      |  366 ++-
> 
> Then the answer is yes.
> 
> But not if you mean these:
> 
>  drivers/pinctrl/pinctrl-tegra20.c                 | 2860 ++++++++++++++++
>  drivers/pinctrl/pinctrl-tegra30.c                 | 3726 +++++++++++++++++++++
> 
> Because the large number of lines come from SoC
> properties rather than board properties.

Yes, that's exactly what I understood.

> The big issue here is whether SoC hardware block
> properties (such as the pins and their names, and their
> groups) should be:
> 
> (A) open-coded in the driver or
> (B) provided as data in the device tree
> 
> nVidia Tegra have opted for the former, Texas OMAP for the latter.
> The in-kernel drivers also do like Tegra. However they
> are smaller due to less combinatorics.
> 
> This means that the Tegra driver gets (quite a bit) bigger and
> the OMAP driver (quite a bit) smaller.
> 
> Then we've had some arguments about this, you
> can make a lot of points for and against one or
> the other, but we have no consensus on the individual
> rank of these arguments.
> 
> I have resorted to the solution found in
> Documentation/ManagementStyle, chapter 1, which
> helpfully talks about handling situations of the type
> (A) vs (B) ... which means no decision on my part until
> we sort it out! People will have to discuss it and start
> ACKing each others patches after finding some
> rough consensus.

Ok, thanks for the explanation.

> > One thing that worries me a bit is the object size of the tegra
> > pinctrl driver: There are now about 70kb pinmux driver binary in
> > each kernel that wants to run on tegra (about the same as the
> > remaining tegra platform code), which can become a bottleneck
> > in future multi-platform kernels that also want to run on a lot of
> > other things.
> 
> This sounds like a correct observation and I think I have said
> the same previously.
> 
> > Will it be possible to eventually put the pinmux driver into a loadable
> > module?
> 
> Tony had made it possible to have pinctrl drivers as modules,
> but some systems may need their pin control up before
> they even bring up the filesystem :-(
> 
> Booting from initramfs and switchroot can solve the above
> but will slow down boot I believe, and ARM systems
> usually don't like that.

Sounds good enough for me. Anyone who wants a single kernel that runs on
a lot different machines (distros like ubuntu, fedora, debian, opensuse)
typically relies on initramfs already, the others can have the code built-in.

	Arnd
