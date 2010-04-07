Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab0DGRYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 13:24:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38691 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125Ab0DGRYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 13:24:34 -0400
Message-ID: <4BBCBD8B.6070701@zytor.com>
Date: Wed, 07 Apr 2010 10:14:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Himanshu Aggarwal <lkml.himanshu@gmail.com>
CC: Chetan Nanda <chetannanda@gmail.com>,
       Xianghua Xiao <xiaoxianghua@gmail.com>,
       Venkatram Tummala <venkatram867@gmail.com>,
       Youngwhan Song <breadncup@gmail.com>,
       Joel Fernandes <agnel.joel@gmail.com>,
       Frank Hu <frank.hu.2001@gmail.com>,
       hayfeng Lee <teklife.kernel@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-kernel@zh-kernel.org" <linux-kernel@zh-kernel.org>,
       "kernelnewbies@nl.linux.org" <kernelnewbies@nl.linux.org>
Subject: Re: why choose 896MB to the start point of ZONE_HIGHMEM
References: <l2y5f6c52c61004060737me670f6e2t6071444c4fd1318b@mail.gmail.com>	 <q2iacff6c2b1004061528t28f1337eq977aabf8fe71bc22@mail.gmail.com>	 <3715922601579231267@unknownmsgid> <4BBBC470.4050002@zytor.com>	 <q2he6bf505b1004061847l31b2fe15v31d1556862d3a2f9@mail.gmail.com>	 <n2uacff6c2b1004061904v5d290fa6v909e2e5fe32ff910@mail.gmail.com>	 <4BBBE976.1000603@zytor.com>	 <n2jacff6c2b1004062248w311d8482w6c64a7bdfded8385@mail.gmail.com>	 <m2me6bf505b1004070510q63926780uac2807ca0ab22db6@mail.gmail.com>	 <k2z7f245da81004070550u5324f6ffyba3e996a3e292a0a@mail.gmail.com> <n2kb114f3281004070948hb510b9b1o80126e2411a98c8d@mail.gmail.com>
In-Reply-To: <n2kb114f3281004070948hb510b9b1o80126e2411a98c8d@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2010 09:48 AM, Himanshu Aggarwal wrote:
> I think for some architectures, the position of highmem is constrained
> by hardware as well.  It is not always a kernel decision and not always
> configurable as in case of x86.


This is correct.

> In case of MIPS32, low memory is between 0 and 512 MB and high memory
> starts above 512 MB. Also the user space is of size 2 GB. 
> 
> Please see the definition of macros PAGE_OFFSET and HIGHMEM_START at :
> http://lxr.linux.no/linux+v2.6.33/arch/mips/include/asm/mach-generic/spaces.h

Right so far...

> This is because MIPS32 processors have KSEG0 and KSEG1 segments lying
> between 0 and 512 MB and KSEG2/3 lies above it. 
> 
> May be someone on the group can confirm this.

Wrong.  I have to say this thread has been just astonishing in the
amount of misinformation.

On MIPS32, userspace is 0-2 GB, kseg0 is 2.0-2.5 GB and kseg1 is 2.5-3.0
GB.  kseg2/3 (3.0-4.0 GB), which invokes the TLB, is used for the
vmalloc/iomap/kmap area.

LOWMEM has to fit inside kseg0, so LOWMEM is limited to 512 MB in thie
current Linux implementation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

