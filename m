Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab2ECVkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:40:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51319 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756516Ab2ECVkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:40:39 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19Twnob+EZT3k7Vbn/QLOGPxOGG6XJg6HtHsqb9Hi
	PkMe16S3lnvBQJ
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH v2] video/sis: Use SiS_DRAMType from init.h and annotate it __devinitconst
Date: Thu, 3 May 2012 23:40:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.3.3; KDE/4.7.4; x86_64; ; )
Cc: Thomas Winischhofer <thomas@winischhofer.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4FA1BF76.8080109@gmx.de>
In-Reply-To: <4FA1BF76.8080109@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205032340.34483.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

> As far as I can see it should be possible to keep the array in
> sis_main.c and just delete it in the header files, shouldn't it? I'd
> prefer to do it this way.

Yes it is absolutely possible to leave it in sis_main.c and remove it from the 
header files. I already thought about this when creating the patch, but 
decided against it, as the 17*5 = 85 bytes are allocated on the stack, while 
they nicely can be put in the .devinit.rodata section ;)

With the patch:
344072  sis_main.o
1200950 sisfb.o
1217491 sisfb.ko

vs without the patch and removing it only from the header:
 344176  sis_main.o
1201056  sisfb.o
1217597  sisfb.ko -> ~100bytes more in the final module.

However I'm fine with this  and will remove it from the header and squash this 
together with the 
"video/sis: Remove unused structs SiS_SDRDRAM_TYPE/SiS_DDRDRAM_TYPE"
I also sent to you.


Thanks,
Peterq
