Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223Ab2GEWgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:36:09 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:32534
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933161Ab2GEWgG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:36:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI9371I1432Izz1202hzz8275bhz2dh2a8h668h839h8e2h8e3hf0ah107ahbe9i)
From: Tabi Timur-B04825 <B04825@freescale.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
CC: Christian Kujau <lists@nerdbynature.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 3.4.0-rc1: No init found
Thread-Topic: 3.4.0-rc1: No init found
Thread-Index: AQHNWv6OtaLHkQLfbE2+BcPL/Oe89Q==
Date: Thu, 5 Jul 2012 22:36:02 +0000
Message-ID: <CAOZdJXVhtxoiY0kvsC+zgrETgd_MxTR+nf+6JDMV5Y-osqVqaw@mail.gmail.com>
References: <alpine.DEB.2.01.1204030008080.4930@trent.utfs.org>
	<1333440522.3040.9.camel@pasglop>
	<alpine.DEB.2.01.1204030953320.4930@trent.utfs.org>
	<4F7C4058.6090405@in.ibm.com>
In-Reply-To: <4F7C4058.6090405@in.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [70.112.118.223]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <7A9A5E8ECF7B924EBC9EB003F2E0EB01@mgd.freescale.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 7:36 AM, Suzuki K. Poulose <suzuki@in.ibm.com> wrote:

>> Not sure if this is related, but at the end of each kernel compilation,
>> the following messages are printed:
>>
>> ------------
>>    SYSMAP  System.map
>>    SYSMAP  .tmp_System.map
>>    WRAP    arch/powerpc/boot/zImage.pmac
>> INFO: Uncompressed kernel (size 0x6e52f8) overlaps the address of the
>> wrapper(0x400000)
>> INFO: Fixing the link_address of wrapper to (0x700000)
>>    WRAP    arch/powerpc/boot/zImage.coff
>> INFO: Uncompressed kernel (size 0x6e52f8) overlaps the address of the
>> wrapper(0x500000)
>> INFO: Fixing the link_address of wrapper to (0x700000)
>>    WRAP    arch/powerpc/boot/zImage.miboot
>> INFO: Uncompressed kernel (size 0x6d4b80) overlaps the address of the
>> wrapper(0x400000)
>> INFO: Fixing the link_address of wrapper to (0x700000)
>>    Building modules, stage 2.
>>    MODPOST 24 modules
>> ------------
>>
>> I started to see these messages in January (around Linux 3.2.0), but never
>> investigated what it was since the produced kernels continued to boot just
>> fine.
>
>
> The above change was added by me. The message is printed when the 'wrapper'
> script finds that decompressed kernel overlaps the 'bootstrap code' which
> does the decompression. So it shifts the 'address' of the bootstrap code to
> the next higher MB. As such it is harmless.

I see this message every time when I build the kernel.  I know it's
harmless, but is this something that can be "fixed"?  That is, can we
change some linker script (or whatever) to make 0x700000 the default
value?  Or maybe modify the wrapper script to just automatically find
the right spot without printing a message?

-- 
Timur Tabi
Linux kernel developer at Freescale
