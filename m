Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394Ab2EDS5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 14:57:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55434 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab2EDS4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 14:56:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wookey <wookey@wookware.org>
Subject: Re: Making ARM multiplatform kernels DT-only?
Date: Fri, 4 May 2012 18:49:51 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Deepak Saxena <dsaxena@linaro.org>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Martin Michlmayr <tbm@cyrius.com>
References: <201205031350.35476.arnd@arndb.de> <201205041517.58830.arnd@arndb.de> <20120504160545.GT27023@stoneboat.aleph1.co.uk>
In-Reply-To: <20120504160545.GT27023@stoneboat.aleph1.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205041849.52046.arnd@arndb.de>
X-Provags-ID: V02:K0:71PZbmM/j5E1eapQTQLKqnt8w1D8qgOYp+Gc0Qlx18p
 syabsm4xN8L6Ascut027Ag+QrD6WUqB6YXjXM4r1K7tOZfQCxh
 owznPzLt5yyFKRJqhD0ORtavcNIxHO2z0m50qPhGKqsMiSL7Re
 nRU7DDJxuMaOnZ00Yl8llDpwpiY7apaYPiCq7sPw1EEIAp4AQq
 K7otCqDMKc5U42Zu6cIb1sZMyeRhp/1SfLRtFH8LCauEwko0Ey
 cbe7WZUThuk/XAJ62vnUH7zyyiyOwAl7N1DoNLm3QKONPVyx22
 dSoK6IFaTkOuPwC7F9LnwogIuC1U39PDVAica4thgnb/JgUQuO
 RiNSa55qHJusrMV28BP8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 May 2012, Wookey wrote:
> > This is very important because distros are obviously the primary consumer
> > of multiplatform builds (aside from build testing). The goal should very
> > much be to reduce the number of distinct kernels that folks like debian,
> > fedora or cyanogenmod have to build.
> 
> Just to be clear, we'd very much like to support more hardware, ideally
> 'everything a significant number of people have', but the overhead to
> the whole distro for each new kernel added to the build (for every
> upload, slowing and potentially breaking releases on all arches) is
> sufficiently high that we have been strict about what is supported. As
> a result a lot of people use Debian with non-distro kernels.

Right, and this is the main motivation behind starting the multiplatform
kernel anyway: supporting more hardware with fewer kernels. Other distros
already aim at supporting only one ARM kernel binary, like things are
on other architectures. One related issue is the kernel binary size, which
we haven't discussed here yet. If we want to build 200 board files into
the kernel, that alone becomes a burden, even if most of it can be discarded
from RAM after the initcalls are done. Supporting only DT-enabled machines
can significantly reduce the size while only reducing the number of supported
boards by a bit, I'd hope.

> Obviously missing things are tegra, dove/armada, omap4. Freerunner
> would have been nice a while back but probably a bit late now. 

I can think of a few more: vexpress would be nice for running something
useful inside of KVM when we get there, various samsung socs are used
in cheap tablet PCs, and stuff like highbank is becoming more relevant
for distros now on the server side.

> It's not clear to me how many omap platforms our 'omap' kernel
> actually serves in practice, and similarly for the other 'generic'
> kernels.
> 
> Obviously any and all progress in the direction of making existing
> coverage or expanded coverage easier/faster/more-reliable/simpler is
> very welcome. 

	Arnd

