Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab2GAOPu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 10:15:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40249 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932418Ab2GAOPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 10:15:47 -0400
References: <4FECB95D.7010200@zytor.com> <cover.1338222460.git.rubini@gnudd.com> <f85fefb10b7a7407b77180be65b18bf0426145b9.1338222461.git.rubini@gnudd.com> <20120701104401.GA4352@mail.gnudd.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20120701104401.GA4352@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 5/6] x86: add CONFIG_ARM_AMBA, selected by STA2X11
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, 01 Jul 2012 07:13:10 -0700
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux@arm.linux.org.uk, x86@kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-arch@vger.kernel.org
Message-ID: <2b797c83-6a3c-4051-841a-a4cfa9d1cae1@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no problem with adding ARM or !X86 dependencies to drivers now and fixing them later or as required.

Alessandro Rubini <rubini@gnudd.com> wrote:

>>> The sta2x11 I/O Hub is a bridge from PCIe to AMBA. It reuses a
>number
>>> of amba drivers and needs to activate core bus support.
>
>> Nacked-by: H. Peter Anvin <hpa@zytor.com>
>> 
>> This brings in tons of code into the x86 all{yes,mod}config builds,
>and 
>> as perhaps one could expect some of it doesn't compile.  For example:
>
>Ok. I apologize for not checking this. Actually, I only fixed the ones
>that I needed to compile.
>
>How should I address the problem? (original code, published on
>sourceforge was simply replicating a number of amba drivers into pci
>drivers, but I don't think massive code duplication is ever sensible,
>thus I preferred to reuse the existing drivers).
>
>I doubt all amba drivers can easily be made x86-compatible.
>I see these possible approaces, all of them with their cons
>
> 1- add STA2X11 dependencies to ARM_AMBA _and_ the drivers that do work
>
>  2- leave CONFIG_ARM_AMBA undefined and play select file in Makefiles
>   using obj-$(CONFIG_STA2X11)
>
>  3- add ARM dependencies to the drivers that do not compile on x86
>
>  any other option?
>
>(1) and (2) bring chipset-specific stuff into the amba world, which is
>bad, especially since I suspect other similar bridges will appear soon.
>
>(3) looks like a temporary hack and stuff can be fixed over time, but
>it has the disadvantage of adding a big number of needless drivers in
>the dsitributions' packages -- like my nacked patch did.
>
>thanks
>/alessandro

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
