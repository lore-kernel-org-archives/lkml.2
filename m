Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015Ab0KRSo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 13:44:29 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58148 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab0KRSo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 13:44:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GdfaX7bFUqqtNVB6PhPm6ulwKQ4nkOFpOBa4Q2prppwbrbs3uG3RnKxhAHEI/HwfNK
         TjuQMD6W+5vYDiyYAEk00u21acxYdezouUyZw+elw1Mytq0LWMkBqxFXvHAe3uZa55QB
         ndqcXtCXqv94sy+rTPhBnwQX1kdvuvkSZfiTk=
Date: Thu, 18 Nov 2010 21:44:21 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Alan Cox <alan@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Feng Tang <feng.tang@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: platform: mrst: check
 platform_device_register() return code
Message-ID: <20101118184419.GA31886@albatros>
References: <1290104207-31279-1-git-send-email-segoon@openwall.com>
 <20101118181814.290811f0@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118181814.290811f0@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 18:18 +0000, Alan Cox wrote:
> >  I cannot compile this driver in next-20101117, so it is not tested
> > at all.
> 
> Compile or test - if it bombs out compiling for you please send me (off
> list the .config that fails so I can fix that
> 
> Otherwise NAK the patch because it needs to do the cleanup but thanks
> for finding the bug - you've done the hard 99%

make -C /home/vasya/linux arch/x86/platform/mrst/vrtc.o
make: Entering directory `/home/vasya/dev/linux-next'
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC      arch/x86/platform/mrst/vrtc.o
arch/x86/platform/mrst/vrtc.c: In function 'mrst_rtc_init':
arch/x86/platform/mrst/vrtc.c:113: error: 'FIX_LNW_VRTC' undeclared (first use in this function)
arch/x86/platform/mrst/vrtc.c:113: error: (Each undeclared identifier is reported only once
arch/x86/platform/mrst/vrtc.c:113: error: for each function it appears in.)
make[1]: *** [arch/x86/platform/mrst/vrtc.o] Error 1

Both with allyesconfig and allmodconfig, x86_64.

These are not patched lines, though.


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
