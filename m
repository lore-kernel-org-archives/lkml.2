Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab2ECVsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:48:10 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:37910 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754494Ab2ECVsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:48:08 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/bhmdobUDbOr71jEomupTuBY2W7t3vroU72ey+wo
	L+AcmjR8B7RJDK
Message-ID: <4FA2FD10.6090306@gmx.de>
Date: Thu, 03 May 2012 21:48:00 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
CC: Thomas Winischhofer <thomas@winischhofer.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] video/sis: Use SiS_DRAMType from init.h and annotate
 it __devinitconst
References: <4FA1BF76.8080109@gmx.de> <201205032340.34483.PeterHuewe@gmx.de>
In-Reply-To: <201205032340.34483.PeterHuewe@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 05/03/2012 09:40 PM, Peter Hüwe wrote:
> Hi Florian,
> 
>> As far as I can see it should be possible to keep the array in
>> sis_main.c and just delete it in the header files, shouldn't it? I'd
>> prefer to do it this way.
> 
> Yes it is absolutely possible to leave it in sis_main.c and remove it from the 
> header files. I already thought about this when creating the patch, but 
> decided against it, as the 17*5 = 85 bytes are allocated on the stack, while 
> they nicely can be put in the .devinit.rodata section ;)

You can still mark it as __devinitconst, I just wanted to have the array
inside a C file, not a header. If you agree with this, I'll change your
new patch that way.

> 
> With the patch:
> 344072  sis_main.o
> 1200950 sisfb.o
> 1217491 sisfb.ko
> 
> vs without the patch and removing it only from the header:
>  344176  sis_main.o
> 1201056  sisfb.o
> 1217597  sisfb.ko -> ~100bytes more in the final module.
> 
> However I'm fine with this  and will remove it from the header and squash this 
> together with the 
> "video/sis: Remove unused structs SiS_SDRDRAM_TYPE/SiS_DDRDRAM_TYPE"
> I also sent to you.

Thanks,

Florian Tobias Schandinat
