Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0EGFrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:47:06 -0400
Received: from ozlabs.org ([203.10.76.45]:53806 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0EGFrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:47:05 -0400
Date: Fri, 7 May 2010 15:40:34 +1000
From: Paul Mackerras <paulus@samba.org>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Paul Mackerras <paulus@au1.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: PPC64 2.6.34-rc6 warning - Is this expected ?
Message-ID: <20100507054034.GB25173@drongo>
References: <1273060251.13463.8.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273060251.13463.8.camel@subratamodak.linux.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 05:20:51PM +0530, Subrata Modak wrote:

> I built 2.6.34-rc6 with the attached Fedora Config file
> (config-2.6.33.1-19.fc13.ppc64) on my P5 Fedora Box and got the
> following warning. Is the following expected ?
> 
> CALL    arch/powerpc/relocs_check.pl
> Building modules, stage 2.
> WARNING: 4 bad relocations
> c00000000007216e R_PPC64_ADDR16_HIGHEST  __ksymtab+0x00000000009dcec8
> c000000000072172 R_PPC64_ADDR16_HIGHER  __ksymtab+0x00000000009dcec8
> c00000000007217a R_PPC64_ADDR16_HI  __ksymtab+0x00000000009dcec8
> c00000000007217e R_PPC64_ADDR16_LO  __ksymtab+0x00000000009dcec8

No, it's not expected.  It's in iSeries code, so you could avoid it
just by disabling CONFIG_ISERIES (I don't think any distro still
supports legacy iSeries).  I'll post a patch to fix the problem
properly.

Paul.
