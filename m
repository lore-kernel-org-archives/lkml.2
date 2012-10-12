Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945969Ab2JLPxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:53:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:64900 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945918Ab2JLPxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:53:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="234134115"
Message-ID: <50783D16.5020309@intel.com>
Date: Fri, 12 Oct 2012 08:53:58 -0700
From: Alexander Duyck <alexander.h.duyck@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH v2 0/8] Improve performance of VM translation on x86_64
References: <20121011204324.12787.30514.stgit@gitlad.jf.intel.com> <CACJDEmomjBk5CkLBWGdyAtKNgV_f39d6kWM5=Ko2Nx5GDmw5Jg@mail.gmail.com> <20121012151517.GC16230@one.firstfloor.org>
In-Reply-To: <20121012151517.GC16230@one.firstfloor.org>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/2012 08:15 AM, Andi Kleen wrote:
>> Could you also add  a blurb in the Documentation/< appropriate file
>> for device driver writes> mentioning the usage of __pa_symbol is
>> preferred?
> Device driver writer's shouldn't use any of this anyways, they should always
> use the PCI DMA APIs and never DMA to the stack or to static variables.
>
> -Andi

__pa_symbol is very architecture specific.  From what I can tell it only
exists for the x86 and mips architectures.  If a device driver is
expected to function on things such as PowerPC you cannot use it. 
Everything I have read indicates that for virtual to physical
translation in drivers it is preferred to use virt_to_phys, not __pa or
__pa_symbol.

Thanks,

Alex
