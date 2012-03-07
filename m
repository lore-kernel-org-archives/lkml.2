Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932661Ab2CGSs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:48:57 -0500
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:42647 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932508Ab2CGSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:48:53 -0500
Date: Wed, 7 Mar 2012 19:36:33 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-arch@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Mike Frysinger <vapier@gentoo.org>, nico@fluxnic.net,
        linux-sh@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        uclinux-dist-devel@blackfin.uclinux.org, sparclinux@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
Message-ID: <20120307183633.GB27213@game.jcrosoft.org>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org>
 <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
 <20120307180815.GA27213@game.jcrosoft.org>
 <4F57AB92.6060907@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F57AB92.6060907@wwwdotorg.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12478911619501304653
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrvdejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:40 Wed 07 Mar     , Stephen Warren wrote:
> On 03/07/2012 11:08 AM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > On 17:30 Tue 06 Mar     , Stephen Warren wrote:
> >> This allows the user to use U-Boot's mkimage's -T kernel_noload option
> >> if their arch Kconfig allows it, and they desire.
> >>
> >> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> >> ---
> >> The next patch enables this new CONFIG_ALLOW_ option for ARM. I assume
> >> that some other architectures will also be able to enable it, but I'm
> >> not familiar enough with any to know which.
> > I'm going to repeat. I don't think any impromevent here.
> > 
> > with no specific kernel load address the uImage for is useless/
> 
> No, the whole point of this type of kernel image is that it doesn't need
> a specific load address; the kernel zImage can run from anywhere in RAM
> (provided AUTO_ZRELADDR is enabled, subject to some slight
> restrictions), and hence the uImage doesn't need to be loaded to or
> moved to any particular location.
> 
> The scripts that U-Boot runs determine where the image gets loaded into
> memory.
so instead of spending time on the uImage add simply the support the zImage to
U-Boot as this AUTO_ZRELADDR have 0 advantage compare to the zImage

> 
> > And this no the job of the kernel to build a boot loader specific boot image
> > format.
> 
> Not everyone agrees with this.
so if a new boot loader apear or a new format the kernel will have to support
it. No
> 
> > And the uImage format here is called the legacy format where now U-Boot
> > support a new format based on DT format.
> > 
> > Will you plan to add it too?
> 
> No. The last time I heard anyone talk about that, it sounded like the
> adoption was basically zero, so it seems pointless. Personally, I find
> creating that kind of image more complex, and don't see any benefits in
> that format either.
> 
> > no sorry I don't think it's the right way to go.
> > 
> > On X86 we boot zImage simply. The new uImage option to do not specify the load
> > address add nothing more than just boot a zImage for kernel point of view.
> 
> U-Boot does not currently have the ability to boot zImage on ARM.
so add it and drop the uImage format
> 
> > Further more on server the vendor will use grub mostly (even on ARM) and will
> > expect to boot a zImage.
> 
> But that is irrelevant for the people who are using U-Boot not grub.
execpt the zIamge is the common boot format for all the server and PC and
other boot loader

Best Regards,
J.
