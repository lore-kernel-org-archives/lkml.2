Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760257Ab0GSI4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 04:56:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52557 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760247Ab0GSI4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 04:56:44 -0400
Subject: Re: [PPC64/Power7 - 2.6.35-rc5] Bad relocation warnings while
	Building a CONFIG_RELOCATABLE kernel with CONFIG_ISERIES enabled
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Michael Neuling <mikey@neuling.org>
Cc: Paul Mackerras <paulus@samba.org>, sachinp <sachinp@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
        Paul Mackerras <paulus@au1.ibm.com>, divya.vikas@in.ibm.com
In-Reply-To: <4635.1279245899@neuling.org>
References: <1273060251.13463.8.camel@subratamodak.linux.ibm.com>
	 <20100507054034.GB25173@drongo>
	 <1279193743.10707.5.camel@subratamodak.linux.ibm.com>
	 <4635.1279245899@neuling.org>
Content-Type: text/plain
Organization: IBM
Date: Mon, 19 Jul 2010 14:26:17 +0530
Message-Id: <1279529778.4985.1.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 12:04 +1000, Michael Neuling wrote:
> > commit e62cee42e66dcca83aae02748535f62e0f564a0c solved the problem for
> > 2.6.34-rc6. However some other bad relocation warnings generated against
> > 2.6.35-rc5 on Power7/ppc64 below:
> > 
> > MODPOST 2004 modules^M
> > WARNING: 2 bad relocations^M
> > c000000000008590 R_PPC64_ADDR32    .text+0x4000000000008460^M
> > c000000000008594 R_PPC64_ADDR32    .text+0x4000000000008598^M
> 
> I can't replicate this with your config with gcc 4.4.4 and binutils
> 2.20.  What are you using?

Well, i also have the following GCC (from Fedora 13 Rawhide)
# gcc --version
gcc (GCC) 4.4.4 20100611 (Red Hat 4.4.4-8)
Copyright (C) 2010 Free Software Foundation, Inc.

and binutils-2.20.51.0.2-22.fc13.ppc,

Regards--
Subrata

> 
> Mikey
> 
> > 
> > Config file attached.
> > 
> > Regards--
> > Subrata
> > 
> > On Fri, 2010-05-07 at 15:40 +1000, Paul Mackerras wrote:
> > > On Wed, May 05, 2010 at 05:20:51PM +0530, Subrata Modak wrote:
> > > 
> > > > I built 2.6.34-rc6 with the attached Fedora Config file
> > > > (config-2.6.33.1-19.fc13.ppc64) on my P5 Fedora Box and got the
> > > > following warning. Is the following expected ?
> > > > 
> > > > CALL    arch/powerpc/relocs_check.pl
> > > > Building modules, stage 2.
> > > > WARNING: 4 bad relocations
> > > > c00000000007216e R_PPC64_ADDR16_HIGHEST  __ksymtab+0x00000000009dcec8
> > > > c000000000072172 R_PPC64_ADDR16_HIGHER  __ksymtab+0x00000000009dcec8
> > > > c00000000007217a R_PPC64_ADDR16_HI  __ksymtab+0x00000000009dcec8
> > > > c00000000007217e R_PPC64_ADDR16_LO  __ksymtab+0x00000000009dcec8
> > > 
> > > No, it's not expected.  It's in iSeries code, so you could avoid it
> > > just by disabling CONFIG_ISERIES (I don't think any distro still
> > > supports legacy iSeries).  I'll post a patch to fix the problem
> > > properly.
> > > 
> > > Paul.

