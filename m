Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab0IXOYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 10:24:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab0IXOYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 10:24:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vernon Mauery <vernux@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v4
Date: Fri, 24 Sep 2010 16:24:18 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
References: <20100921224610.GO13162@lucy> <201009241512.39311.arnd@arndb.de> <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
In-Reply-To: <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009241624.19118.arnd@arndb.de>
X-Provags-ID: V02:K0:UjTIav98t971M1AHYtPbJQZkqc1rKVuZ1U2QbT1+AXA
 wMVMzeK3mdfFpIWfr2QxutF6Xv9kEzbmY7wSigURUJqGEfszz/
 4ugUM+IGLQjJOPdF+JI8neyaxaRStZ43spmi9WEMpM0fvjl9se
 tvnLOQtaKXDOqrHgWilMwMQ3A5XfgCwzg3kLQUh2Xfd91NRjfd
 73CtEpWUcp/9vUE6KBLpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 September 2010, Vernon Mauery wrote:
> >> +static DEFINE_MUTEX(rtl_lock);
> >> +static struct ibm_rtl_table __iomem *rtl_table = NULL;
> >> +static void __iomem *ebda_map;
> >> +static void __iomem *rtl_cmd_iomem_addr = NULL;
> >> +static u32 rtl_cmd_port_addr;
> >> +static enum rtl_addr_type rtl_cmd_type;
> >> +static u8 rtl_cmd_width;
> >
> > This is somewhat inconsistent, some of these are implicitly initialized,
> > others have an explicit "= NULL". I would recommend leaving out the
> > initialization, which is the historic way to do this in the kernel.
> 
> The variables that have an explicit initialization are the variables
> that I read before I write.  It just looks funny to me to read a
> variable that hasn't been initialized.  But I can axe the
> initializations for the sake of consistency.

Ok. Global variables are by definition initialized to zero.
Old gcc versions used to allocate space in the .data section
if you had explicit = NULL statements while they would end
up in .bss otherwise, resulting in a smaller binary image.

With newer gcc versions, it doesn't make a difference, but
many people have the "don't initialize globals to zero" meme
hardcoded to their brains now ;-)

	Arnd
