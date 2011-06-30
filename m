Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab1F3Kxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 06:53:47 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:52075 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750991Ab1F3Kxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 06:53:42 -0400
Date: Thu, 30 Jun 2011 11:52:54 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        florian@linux-mips.org, Florian Fainelli <florian@openwrt.org>,
        linux-arch@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: SB16 build error.
Message-ID: <20110630105254.GA25732@linux-mips.org>
References: <20110630091754.GA12119@linux-mips.org>
 <s5h8vsjy68z.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5h8vsjy68z.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:15:56PM +0200, Takashi Iwai wrote:

> At Thu, 30 Jun 2011 10:17:54 +0100,
> Ralf Baechle wrote:
> > 
> > Found on a MIPS build but certain other architectures will have the same
> > issue:
> > 
> >   CC      sound/isa/sb/sb16_csp.o
> > sound/isa/sb/sb16_csp.c: In function ‘snd_sb_csp_ioctl’:
> > sound/isa/sb/sb16_csp.c:228: error: case label does not reduce to an integer constant
> > make[1]: *** [sound/isa/sb/sb16_csp.o] Error 1
> > make: *** [sound/isa/sb/sb16_csp.o] Error 2
> > 
> > This error message is caused by the _IOC_TYPECHECK() error check triggering
> > due to excessive ioctl size on Alpha, PowerPC, MIPS and SPARC which define
> > _IOC_SIZEBITS as 13.  On all other architectures define it as 14 so struct
> > snd_sb_csp_microcode with it's little over 12kB will just about fit into
> > the 16kB limit.
> 
> What about the patch below?

I have no idea how big the soundblaster microcode being loaded actually is,
that is if the reduced size of 0x1f00 will be sufficient.  Aside of that I
don't see a problem - I don't see how the old ioctl can possibly have been
used before so there isn't a compatibility problem.

Or you could entirely sidestep the problem and use request_firmware() but
I guess that's more effort than you want to invest.

> This is an old ISA driver, so the impact must be very low.

True.  I notice that sort of stuff in automated mass builds - not
necessarily the sort of kernels one would actually use.  Still build errors
are annoying :)

  Ralf
