Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab1DHAcj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 20:32:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:40647 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757197Ab1DHAch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:32:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,320,1299484800"; 
   d="scan'208";a="625279420"
Message-ID: <4D9E579C.3030101@intel.com>
Date: Fri, 08 Apr 2011 08:32:28 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Richard Henderson <rth@twiddle.net>, Mikael Starvik <starvik@axis.com>,
        David Howells <dhowells@redhat.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Chen Liqin <liqin.chen@sunplusct.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ingo Molnar <mingo@redhat.com>, Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH -v2 1/4] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
References: <1302139746-1030-1-git-send-email-ying.huang@intel.com> <1302139746-1030-2-git-send-email-ying.huang@intel.com> <20110407173953.GB17049@n2100.arm.linux.org.uk>
In-Reply-To: <20110407173953.GB17049@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 01:39 AM, Russell King - ARM Linux wrote:
> On Thu, Apr 07, 2011 at 09:29:03AM +0800, Huang Ying wrote:
>> cmpxchg() is widely used by lockless code, including NMI-safe lockless
>> code.  But on some architectures, the cmpxchg() implementation is not
>> NMI-safe, on these architectures the lockless code may need to a
>> spin_trylock_irqsave() based implementation.
>>
>> This patch adds a Kconfig option: ARCH_HAVE_NMI_SAFE_CMPXCHG, so that
>> NMI-safe lockless code can depend on it or provide different
>> implementation according to it.
>>
>> On many architectures, cmpxchg is only NMI-safe for several specific
>> operand sizes. So, ARCH_HAVE_NMI_SAFE_CMPXCHG define in this patch
>> only guarantees cmpxchg is NMI-safe for sizeof(unsigned long).
> 
> As this no longer touches any ARM code, I thinky you can drop me from the
> CC list.  Thanks.

OK.  Will do this.

Best Regards,
Huang Ying
