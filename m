Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab0GPCFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 22:05:04 -0400
Received: from ozlabs.org ([203.10.76.45]:39464 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758673Ab0GPCFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 22:05:01 -0400
To: subrata@linux.vnet.ibm.com
cc: Paul Mackerras <paulus@samba.org>, sachinp <sachinp@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        Paul Mackerras <paulus@au1.ibm.com>, divya.vikas@in.ibm.com
Subject: Re: [PPC64/Power7 - 2.6.35-rc5] Bad relocation warnings while Building a CONFIG_RELOCATABLE kernel with CONFIG_ISERIES enabled
In-reply-to: <1279193743.10707.5.camel@subratamodak.linux.ibm.com>
References: <1273060251.13463.8.camel@subratamodak.linux.ibm.com> <20100507054034.GB25173@drongo> <1279193743.10707.5.camel@subratamodak.linux.ibm.com>
Comments: In-reply-to Subrata Modak <subrata@linux.vnet.ibm.com>
   message dated "Thu, 15 Jul 2010 17:05:43 +0530."
From: Michael Neuling <mikey@neuling.org>
Date: Fri, 16 Jul 2010 12:04:59 +1000
Message-ID: <4635.1279245899@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> commit e62cee42e66dcca83aae02748535f62e0f564a0c solved the problem for
> 2.6.34-rc6. However some other bad relocation warnings generated against
> 2.6.35-rc5 on Power7/ppc64 below:
> 
> MODPOST 2004 modules^M
> WARNING: 2 bad relocations^M
> c000000000008590 R_PPC64_ADDR32    .text+0x4000000000008460^M
> c000000000008594 R_PPC64_ADDR32    .text+0x4000000000008598^M

I can't replicate this with your config with gcc 4.4.4 and binutils
2.20.  What are you using?

Mikey

> 
> Config file attached.
> 
> Regards--
> Subrata
> 
> On Fri, 2010-05-07 at 15:40 +1000, Paul Mackerras wrote:
> > On Wed, May 05, 2010 at 05:20:51PM +0530, Subrata Modak wrote:
> > 
> > > I built 2.6.34-rc6 with the attached Fedora Config file
> > > (config-2.6.33.1-19.fc13.ppc64) on my P5 Fedora Box and got the
> > > following warning. Is the following expected ?
> > > 
> > > CALL    arch/powerpc/relocs_check.pl
> > > Building modules, stage 2.
> > > WARNING: 4 bad relocations
> > > c00000000007216e R_PPC64_ADDR16_HIGHEST  __ksymtab+0x00000000009dcec8
> > > c000000000072172 R_PPC64_ADDR16_HIGHER  __ksymtab+0x00000000009dcec8
> > > c00000000007217a R_PPC64_ADDR16_HI  __ksymtab+0x00000000009dcec8
> > > c00000000007217e R_PPC64_ADDR16_LO  __ksymtab+0x00000000009dcec8
> > 
> > No, it's not expected.  It's in iSeries code, so you could avoid it
> > just by disabling CONFIG_ISERIES (I don't think any distro still
> > supports legacy iSeries).  I'll post a patch to fix the problem
> > properly.
> > 
> > Paul.
