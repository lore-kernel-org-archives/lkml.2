Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762703Ab2DLUcp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:32:45 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:63957 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab2DLUcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:32:43 -0400
Date: Thu, 12 Apr 2012 22:32:20 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: hpa@zytor.com
Cc: mingo@elte.hu, akpm@linux-foundation.org, jbarnes@virtuousgeek.org,
        fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        giancarlo.asnaghi@st.com, alan@linux.intel.com
Subject: Re: [PATCH V4 1/3] x86: introduce CONFIG_X86_DEV_DMA_OPS
Message-ID: <20120412203220.GA27629@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <4F87388C.300@zytor.com>
References: <4F87388C.300@zytor.com>  <4F87186B.9010303@zytor.com>
  <cover.1331622735.git.rubini@gnudd.com>
 <5965c5b1f828732b3599131fb21070aba6f1a386.1331622735.git.rubini@gnudd.com>
 <20120314065614.GB27480@elte.hu> <20120412201533.GA26533@mail.gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>   config MAX_DMA_PADDR
>>           int
>>           default 536870912 if MAX_DMA_PADDR_512M
>>           default 16777216
>> 
>>   config MAX_DMA_PADDR_512M
>>           bool
>> 
>> (actually, we'd benefit from being able to use hex in defaults)
>> 
>> Is this worth exploring, to possibly submit a patch in this direction?
>> 
> 
> Not as a compile-time patch.

Why not? CONFIG_ISA is a compile-time choice. I thought that if you
compile for non-ISA systems you may reuse the zone mechanism with a
different split.

But if not a compile-time thing, would you accept it at run time?
I feel it's not a beautiful approach, because it must clearly be
masked by #ifndef CONFIG_ISA or such. Worse, you must know the zone
split at the beginning, before you scan the PCI bus and find your
devices.

thanks
/alessandro
