Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab2GXTYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 15:24:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab2GXTYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 15:24:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [08/36] AArch64: Kernel booting and initialisation
Date: Tue, 24 Jul 2012 18:53:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: Christopher Covington <cov@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Domenico Andreoli <cavokz@gmail.com>
References: <1341608777-12982-9-git-send-email-catalin.marinas@arm.com> <500DB986.7090309@codeaurora.org> <20120724162404.GB29519@arm.com>
In-Reply-To: <20120724162404.GB29519@arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207241853.16625.arnd@arndb.de>
X-Provags-ID: V02:K0:Y7Uog3QdL34VpCiL955gokT5gSHJCOxGjHYvtvgv1C2
 p05ThIiKVqrWlc5iVC7WdBSqxTdJxqMuwLMdjiudYRiITFpTun
 t4KihJwpaoD2aaZJ0tFC//fIRObpyeJJIjWnFIojwplMJqtaYy
 LLp1B2oZdqZ1gwckbHP8ELBQKFIn/uvPl4lxZxYJhoTvqOjXOx
 nmd1yc2Pyz8T1QAsle8n0ucF5Y4yTPNP5R3SxBEdfjYV6KF6fG
 Bp6fFqipUSohD6jlAEsebfflq/nxQW0Mkcq32D65Z+IOU6fQYD
 E4m9SYAlSRz3DMBVS20hpvJ3n2oMv16XegaJXktwowfKcl0Uv0
 L1Q7LD2SLqYFuTDovRUA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 July 2012, Catalin Marinas wrote:
> On Mon, Jul 23, 2012 at 09:52:22PM +0100, Christopher Covington wrote:
> > Hi Catalin and Stephen,
> > 
> > Catalin Marinas - July 8, 2012, 9:18 a.m.
> > > On Fri, Jul 06, 2012 at 10:32:54PM +0100, Stephen Warren wrote:
> > > 
> > >> Also, on Tegra at least and perhaps OMAP too, there are a few parts
> > >> of earlyprintk serial port setup (i.e. port selection) which happen
> > >> as part of the decompressor rather than the main kernel image, so
> > >> we'd have to re-jig that too.
> > > 
> > > Whatever we did on AArch32, if it was useful and we want to follow a
> > > similar model it needs porting given that the code cannot be shared. So
> > > there is nothing to re-jig but rather implement.
> > > 
> > > As for earlyprintk, you can initialise it in the decompressed kernel
> > > anyway. But even though it's a useful debugging tool, it goes against
> > > the single Image aim (at least the current printascii/addruart
> > > implementation). I don't have a proper implementation yet.
> > 
> > Would DCC [1] be a reasonably commonly available early printk mechanism
> > for the single image to provide?
> 
> Yes, this can be implemented but I think it has its own restrictions,
> requiring a JTAG connection.

Right, which means that it's not generic and we still need to make
a decision for a how we want to solve the underlying problem. The
options I see are:

1. Have no earlyprintk before loading the console drivers
2. Make the series from Domenico architecture independent code
3. Reimplement a layer like that, differently
4. Make it a compile-time option and allow this only for
   low level debugging purposes but disable it in distro kernels.

	Arnd
