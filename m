Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1F3MoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:44:01 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:52788 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751159Ab1F3Mnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:43:53 -0400
Date: Thu, 30 Jun 2011 13:43:33 +0100
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
Message-ID: <20110630124333.GA9727@linux-mips.org>
References: <20110630091754.GA12119@linux-mips.org>
 <s5h8vsjy68z.wl%tiwai@suse.de>
 <20110630105254.GA25732@linux-mips.org>
 <s5h39iry3xp.wl%tiwai@suse.de>
 <s5hy60jwocc.wl%tiwai@suse.de>
 <20110630123212.GA6690@linux-mips.org>
 <s5hoc1fwl37.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hoc1fwl37.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 02:38:20PM +0200, Takashi Iwai wrote:

> > In userland an empty definition will be used for _IOC_TYPECHECK so there
> > won't be an error.  So userland already is already using the existing
> > value for SNDRV_SB_CSP_IOCTL_LOAD_CODE ...
> 
> Right.  It has an invalid direction (3), but apps won't care such
> details anyway.
> 
> > With a crude hack like
> > 
> > #define SNDRV_SB_CSP_IOCTL_LOAD_CODE				\
> > 	_IOC(_IOC_WRITE,'H', 0x11, sizeof(struct snd_sb_csp_microcode))
> > 
> > error checking can be bypassed and all will be fine as long as the
> > resulting value doesn't result in in a a duplicate case value - which it
> > doesn't, at least not in my testing.
> > 
> > Should work but isn't nice.
> 
> Indeed.  But which is uglier is hard to answer :)
> 
> If you are fine with the hacked ioctl number above, I can put it
> with some comments.  This won't break anything, at least.

Go ahead then and yes, this really deserves a comment.

  Ralf
