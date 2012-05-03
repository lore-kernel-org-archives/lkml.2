Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab2ECVMN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:12:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17607 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004Ab2ECVML convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:12:11 -0400
MIME-Version: 1.0
Message-ID: <6436426b-5c46-4457-9d78-6b0af5ce4a3b@default>
Date: Thu, 3 May 2012 14:11:47 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Autif Khan <autif.mlist@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Randy Dunlap <rdunlap@xenotime.net>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: RE: [PATCH] drivers: staging: zcache: fix Kconfig crypto dependency
References: <1335231230-29344-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <4F9B3BEB.1040805@xenotime.net>
In-Reply-To: <4F9B3BEB.1040805@xenotime.net>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.6  (510070) [OL
 12.0.6607.1000 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Randy Dunlap [mailto:rdunlap@xenotime.net]
> Sent: Friday, April 27, 2012 6:38 PM
> To: Seth Jennings
> Cc: Greg Kroah-Hartman; devel@driverdev.osuosl.org; Dan Magenheimer; Autif Khan; Konrad Rzeszutek
> Wilk; linux-kernel@vger.kernel.org; linux-mm@kvack.org; Robert Jennings; Nitin Gupta
> Subject: Re: [PATCH] drivers: staging: zcache: fix Kconfig crypto dependency
> 
> On 04/23/2012 06:33 PM, Seth Jennings wrote:
> 
> > ZCACHE is a boolean in the Kconfig.  When selected, it
> > should require that CRYPTO be builtin (=y).
> >
> > Currently, ZCACHE=y and CRYPTO=m is a valid configuration
> > when it should not be.
> >
> > This patch changes the zcache Kconfig to enforce this
> > dependency.
> >
> > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Not sure if you need my approval, but I just in case you are waiting
for it:

Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

> > ---
> >  drivers/staging/zcache/Kconfig |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/staging/zcache/Kconfig b/drivers/staging/zcache/Kconfig
> > index 3ed2c8f..7048e01 100644
> > --- a/drivers/staging/zcache/Kconfig
> > +++ b/drivers/staging/zcache/Kconfig
> > @@ -2,7 +2,7 @@ config ZCACHE
> >  	bool "Dynamic compression of swap pages and clean pagecache pages"
> >  	# X86 dependency is because zsmalloc uses non-portable pte/tlb
> >  	# functions
> > -	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO && X86
> > +	depends on (CLEANCACHE || FRONTSWAP) && CRYPTO=y && X86
> >  	select ZSMALLOC
> >  	select CRYPTO_LZO
> >  	default n
> 
> 
> 
> --
> ~Randy
