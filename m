Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab2A3Szd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 13:55:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab2A3Szc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 13:55:32 -0500
Date: Mon, 30 Jan 2012 13:55:18 -0500
From: Dave Jones <davej@redhat.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Hiroshi Miura <miura@da-cha.org>,
        cpufreq@vger.kernel.org
Subject: Re: [PATCH -next] cpufreq: fix gx-suspmod.c build
Message-ID: <20120130185518.GA493@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Hiroshi Miura <miura@da-cha.org>, cpufreq@vger.kernel.org
References: <20120130144102.8d202c7d8eccd503a86b3053@canb.auug.org.au>
 <4F26F242.1060903@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F26F242.1060903@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 30, 2012 at 11:40:50AM -0800, Randy Dunlap wrote:
 > From: Randy Dunlap <rdunlap@xenotime.net>
 > 
 > Fix build error & warnings:

Needs to go through Andi, or Greg, or whoever is carrying those
cpu device autoload patches now. (I lost track)

	Dave

 
 > drivers/cpufreq/gx-suspmod.c:175:35: error: macro "MODULE_DEVICE_TABLE" requires 2 arguments, but only 1 given
 > drivers/cpufreq/gx-suspmod.c:175:1: warning: data definition has no type or storage class
 > drivers/cpufreq/gx-suspmod.c:175:1: warning: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE'
 > 
 > Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
 > Cc: Hiroshi Miura <miura@da-cha.org>
 > Cc:	Dave Jones <davej@redhat.com>
 > Cc:	cpufreq@vger.kernel.org
 > ---
 >  drivers/cpufreq/gx-suspmod.c |    2 +-
 >  1 file changed, 1 insertion(+), 1 deletion(-)
 > 
 > --- linux-next-20120130.orig/drivers/cpufreq/gx-suspmod.c
 > +++ linux-next-20120130/drivers/cpufreq/gx-suspmod.c
 > @@ -172,7 +172,7 @@ static struct pci_device_id gx_chipset_t
 >  	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5510), },
 >  	{ 0, },
 >  };
 > -MODULE_DEVICE_TABLE(gx_chipset_tbl);
 > +MODULE_DEVICE_TABLE(x86cpu, gx_chipset_tbl);
 >  
 >  static void gx_write_byte(int reg, int value)
 >  {
---end quoted text---
