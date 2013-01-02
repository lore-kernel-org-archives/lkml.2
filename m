Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3ABTNr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 14:13:47 -0500
Received: from relay1.sgi.com ([192.48.179.29]:50262 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab3ABTNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 14:13:45 -0500
Message-ID: <50E486E7.1080903@sgi.com>
Date: Wed, 2 Jan 2013 13:13:43 -0600
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, <linux-efi@vger.kernel.org>,
        <matt.fleming@intel.com>, <tglx@linutronix.de>, <mingo@redhat.com>
Subject: Re: BUG: unable to handle kernel paging request at 000000effd870020
References: <20130102172107.GA26761@gulag1.americas.sgi.com> <50E476C2.7060300@zytor.com>
In-Reply-To: <50E476C2.7060300@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.130]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 12:04 PM, H. Peter Anvin wrote:
> On 01/02/2013 09:21 AM, Nathan Zimmer wrote:
>> I am getting an early boot problem. It only happens on the larger of the
>> machines I haven't seen it crop up on machines with more then 512 GB of ram.
>> It shows in the latest linus kernel too.
>>
>> I am (wildly) guessing that what is happening is that the new_memmap that is
>> being passed to bios is somehow placed incorrectly.
>> I have come up with a workaround.  By placing it the DMA area the issue goes
>> away but that doesn't seem like a real fix.
>>
> What does your memory map look like?
>
> 	-hpa
>


efi: EFI v2.10 by INTEL
efi:  ACPI 2.0=0x78d40014  SMBIOS=0x78bd2000  UVsystab=0x76314000
efi: mem00: type=3, attr=0xf, 
range=[0x0000000000000000-0x0000000000001000) (0MB)
efi: mem01: type=7, attr=0xf, 
range=[0x0000000000001000-0x000000000000e000) (0MB)
efi: mem02: type=3, attr=0xf, 
range=[0x000000000000e000-0x0000000000010000) (0MB)
efi: mem03: type=7, attr=0xf, 
range=[0x0000000000010000-0x000000000005f000) (0MB)
efi: mem04: type=4, attr=0xf, 
range=[0x000000000005f000-0x0000000000060000) (0MB)
efi: mem05: type=3, attr=0xf, 
range=[0x0000000000060000-0x000000000008f000) (0MB)
efi: mem06: type=10, attr=0xf, 
range=[0x000000000008f000-0x0000000000090000) (0MB)
efi: mem07: type=3, attr=0xf, 
range=[0x0000000000090000-0x00000000000a0000) (0MB)
efi: mem08: type=2, attr=0xf, 
range=[0x0000000000100000-0x0000000000900000) (8MB)
efi: mem09: type=7, attr=0xf, 
range=[0x0000000000900000-0x0000000000c00000) (3MB)
efi: mem10: type=3, attr=0xf, 
range=[0x0000000000c00000-0x0000000001000000) (4MB)
efi: mem11: type=7, attr=0xf, 
range=[0x0000000001000000-0x00000000731a7000) (1825MB)
efi: mem12: type=2, attr=0xf, 
range=[0x00000000731a7000-0x00000000738f6000) (7MB)
efi: mem13: type=1, attr=0xf, 
range=[0x00000000738f6000-0x0000000073934000) (0MB)
efi: mem14: type=7, attr=0xf, 
range=[0x0000000073934000-0x000000007394b000) (0MB)
efi: mem15: type=2, attr=0xf, 
range=[0x000000007394b000-0x0000000073950000) (0MB)
efi: mem16: type=7, attr=0xf, 
range=[0x0000000073950000-0x0000000073951000) (0MB)
efi: mem17: type=2, attr=0xf, 
range=[0x0000000073951000-0x0000000073954000) (0MB)
efi: mem18: type=4, attr=0xf, 
range=[0x0000000073954000-0x0000000073955000) (0MB)
efi: mem19: type=2, attr=0xf, 
range=[0x0000000073955000-0x0000000073970000) (0MB)
efi: mem20: type=4, attr=0xf, 
range=[0x0000000073970000-0x0000000073976000) (0MB)
efi: mem21: type=2, attr=0xf, 
range=[0x0000000073976000-0x0000000073978000) (0MB)
efi: mem22: type=4, attr=0xf, 
range=[0x0000000073978000-0x00000000739d4000) (0MB)
efi: mem23: type=7, attr=0xf, 
range=[0x00000000739d4000-0x00000000739d5000) (0MB)
efi: mem24: type=4, attr=0xf, 
range=[0x00000000739d5000-0x00000000739d6000) (0MB)
efi: mem25: type=2, attr=0xf, 
range=[0x00000000739d6000-0x00000000739d7000) (0MB)
efi: mem26: type=4, attr=0xf, 
range=[0x00000000739d7000-0x00000000739ff000) (0MB)
efi: mem27: type=2, attr=0xf, 
range=[0x00000000739ff000-0x0000000073a13000) (0MB)
efi: mem28: type=4, attr=0xf, 
range=[0x0000000073a13000-0x0000000073a15000) (0MB)
efi: mem29: type=2, attr=0xf, 
range=[0x0000000073a15000-0x0000000073a1e000) (0MB)
efi: mem30: type=4, attr=0xf, 
range=[0x0000000073a1e000-0x0000000073ba2000) (1MB)
efi: mem31: type=1, attr=0xf, 
range=[0x0000000073ba2000-0x0000000073c63000) (0MB)
efi: mem32: type=4, attr=0xf, 
range=[0x0000000073c63000-0x0000000073ca0000) (0MB)
efi: mem33: type=2, attr=0xf, 
range=[0x0000000073ca0000-0x0000000073ca1000) (0MB)
efi: mem34: type=4, attr=0xf, 
range=[0x0000000073ca1000-0x0000000073ca2000) (0MB)
efi: mem35: type=2, attr=0xf, 
range=[0x0000000073ca2000-0x0000000073cab000) (0MB)
efi: mem36: type=4, attr=0xf, 
range=[0x0000000073cab000-0x0000000073cd6000) (0MB)
efi: mem37: type=3, attr=0xf, 
range=[0x0000000073cd6000-0x0000000073cec000) (0MB)
efi: mem38: type=4, attr=0xf, 
range=[0x0000000073cec000-0x0000000075a31000) (29MB)
efi: mem39: type=6, attr=0x800000000000000f, 
range=[0x0000000075a31000-0x0000000075a32000) (0MB)
efi: mem40: type=4, attr=0xf, 
range=[0x0000000075a32000-0x0000000075a33000) (0MB)
efi: mem41: type=5, attr=0x800000000000000f, 
range=[0x0000000075a33000-0x0000000075a3c000) (0MB)
efi: mem42: type=6, attr=0x800000000000000f, 
range=[0x0000000075a3c000-0x0000000075a3d000) (0MB)
efi: mem43: type=5, attr=0x800000000000000f, 
range=[0x0000000075a3d000-0x0000000075a58000) (0MB)
efi: mem44: type=3, attr=0xf, 
range=[0x0000000075a58000-0x0000000075a5c000) (0MB)
efi: mem45: type=4, attr=0xf, 
range=[0x0000000075a5c000-0x0000000075c53000) (1MB)
efi: mem46: type=3, attr=0xf, 
range=[0x0000000075c53000-0x0000000075c56000) (0MB)
efi: mem47: type=4, attr=0xf, 
range=[0x0000000075c56000-0x0000000075cbc000) (0MB)
efi: mem48: type=3, attr=0xf, 
range=[0x0000000075cbc000-0x0000000075cbe000) (0MB)
efi: mem49: type=4, attr=0xf, 
range=[0x0000000075cbe000-0x0000000075cc0000) (0MB)
efi: mem50: type=5, attr=0x800000000000000f, 
range=[0x0000000075cc0000-0x0000000075cc5000) (0MB)
efi: mem51: type=3, attr=0xf, 
range=[0x0000000075cc5000-0x0000000075cc7000) (0MB)
efi: mem52: type=4, attr=0xf, 
range=[0x0000000075cc7000-0x0000000075ccb000) (0MB)
efi: mem53: type=3, attr=0xf, 
range=[0x0000000075ccb000-0x0000000075ccf000) (0MB)
efi: mem54: type=0, attr=0xf, 
range=[0x0000000075ccf000-0x0000000075cd8000) (0MB)
efi: mem55: type=4, attr=0xf, 
range=[0x0000000075cd8000-0x0000000075cdb000) (0MB)
efi: mem56: type=3, attr=0xf, 
range=[0x0000000075cdb000-0x0000000075cdd000) (0MB)
efi: mem57: type=4, attr=0xf, 
range=[0x0000000075cdd000-0x0000000075cde000) (0MB)
efi: mem58: type=3, attr=0xf, 
range=[0x0000000075cde000-0x0000000075ce4000) (0MB)
efi: mem59: type=4, attr=0xf, 
range=[0x0000000075ce4000-0x0000000075ce5000) (0MB)
efi: mem60: type=3, attr=0xf, 
range=[0x0000000075ce5000-0x0000000075cec000) (0MB)
efi: mem61: type=4, attr=0xf, 
range=[0x0000000075cec000-0x0000000075cee000) (0MB)
efi: mem62: type=3, attr=0xf, 
range=[0x0000000075cee000-0x0000000075cf6000) (0MB)
efi: mem63: type=4, attr=0xf, 
range=[0x0000000075cf6000-0x0000000075cf7000) (0MB)
efi: mem64: type=3, attr=0xf, 
range=[0x0000000075cf7000-0x0000000075cfa000) (0MB)
efi: mem65: type=4, attr=0xf, 
range=[0x0000000075cfa000-0x0000000075cfb000) (0MB)
efi: mem66: type=3, attr=0xf, 
range=[0x0000000075cfb000-0x0000000075cff000) (0MB)
efi: mem67: type=4, attr=0xf, 
range=[0x0000000075cff000-0x0000000075d00000) (0MB)
efi: mem68: type=3, attr=0xf, 
range=[0x0000000075d00000-0x0000000075d02000) (0MB)
efi: mem69: type=4, attr=0xf, 
range=[0x0000000075d02000-0x0000000075d04000) (0MB)
efi: mem70: type=3, attr=0xf, 
range=[0x0000000075d04000-0x0000000075d06000) (0MB)
efi: mem71: type=4, attr=0xf, 
range=[0x0000000075d06000-0x0000000075d07000) (0MB)
efi: mem72: type=5, attr=0x800000000000000f, 
range=[0x0000000075d07000-0x0000000075d0f000) (0MB)
efi: mem73: type=4, attr=0xf, 
range=[0x0000000075d0f000-0x0000000075d10000) (0MB)
efi: mem74: type=3, attr=0xf, 
range=[0x0000000075d10000-0x0000000075d18000) (0MB)
efi: mem75: type=5, attr=0x800000000000000f, 
range=[0x0000000075d18000-0x0000000075d1a000) (0MB)
efi: mem76: type=4, attr=0xf, 
range=[0x0000000075d1a000-0x0000000075d1b000) (0MB)
efi: mem77: type=3, attr=0xf, 
range=[0x0000000075d1b000-0x0000000075d1e000) (0MB)
efi: mem78: type=4, attr=0xf, 
range=[0x0000000075d1e000-0x0000000075d21000) (0MB)
efi: mem79: type=3, attr=0xf, 
range=[0x0000000075d21000-0x0000000075d28000) (0MB)
efi: mem80: type=4, attr=0xf, 
range=[0x0000000075d28000-0x0000000075d29000) (0MB)
efi: mem81: type=3, attr=0xf, 
range=[0x0000000075d29000-0x0000000075d2c000) (0MB)
efi: mem82: type=4, attr=0xf, 
range=[0x0000000075d2c000-0x0000000075d2e000) (0MB)
efi: mem83: type=3, attr=0xf, 
range=[0x0000000075d2e000-0x0000000075d3c000) (0MB)
efi: mem84: type=4, attr=0xf, 
range=[0x0000000075d3c000-0x0000000075d3d000) (0MB)
efi: mem85: type=3, attr=0xf, 
range=[0x0000000075d3d000-0x0000000075d45000) (0MB)
efi: mem86: type=4, attr=0xf, 
range=[0x0000000075d45000-0x0000000075d46000) (0MB)
efi: mem87: type=3, attr=0xf, 
range=[0x0000000075d46000-0x0000000075d4f000) (0MB)
efi: mem88: type=4, attr=0xf, 
range=[0x0000000075d4f000-0x0000000075d53000) (0MB)
efi: mem89: type=3, attr=0xf, 
range=[0x0000000075d53000-0x0000000075d5c000) (0MB)
efi: mem90: type=4, attr=0xf, 
range=[0x0000000075d5c000-0x0000000075d5d000) (0MB)
efi: mem91: type=3, attr=0xf, 
range=[0x0000000075d5d000-0x0000000075d63000) (0MB)
efi: mem92: type=4, attr=0xf, 
range=[0x0000000075d63000-0x0000000075d64000) (0MB)
efi: mem93: type=5, attr=0x800000000000000f, 
range=[0x0000000075d64000-0x0000000075d66000) (0MB)
efi: mem94: type=6, attr=0x800000000000000f, 
range=[0x0000000075d66000-0x0000000075d6b000) (0MB)
efi: mem95: type=5, attr=0x800000000000000f, 
range=[0x0000000075d6b000-0x0000000075d75000) (0MB)
efi: mem96: type=4, attr=0xf, 
range=[0x0000000075d75000-0x0000000075d77000) (0MB)
efi: mem97: type=5, attr=0x800000000000000f, 
range=[0x0000000075d77000-0x0000000075d85000) (0MB)
efi: mem98: type=4, attr=0xf, 
range=[0x0000000075d85000-0x0000000075d87000) (0MB)
efi: mem99: type=3, attr=0xf, 
range=[0x0000000075d87000-0x0000000075da1000) (0MB)
efi: mem100: type=4, attr=0xf, 
range=[0x0000000075da1000-0x0000000075da2000) (0MB)
efi: mem101: type=3, attr=0xf, 
range=[0x0000000075da2000-0x0000000075da8000) (0MB)
efi: mem102: type=4, attr=0xf, 
range=[0x0000000075da8000-0x000000007615c000) (3MB)
efi: mem103: type=3, attr=0xf, 
range=[0x000000007615c000-0x0000000076162000) (0MB)
efi: mem104: type=4, attr=0xf, 
range=[0x0000000076162000-0x0000000076163000) (0MB)
efi: mem105: type=3, attr=0xf, 
range=[0x0000000076163000-0x00000000761d6000) (0MB)
efi: mem106: type=4, attr=0xf, 
range=[0x00000000761d6000-0x00000000761d9000) (0MB)
efi: mem107: type=3, attr=0xf, 
range=[0x00000000761d9000-0x00000000761e0000) (0MB)
efi: mem108: type=4, attr=0xf, 
range=[0x00000000761e0000-0x00000000761e1000) (0MB)
efi: mem109: type=5, attr=0x800000000000000f, 
range=[0x00000000761e1000-0x0000000076211000) (0MB)
efi: mem110: type=4, attr=0xf, 
range=[0x0000000076211000-0x0000000076214000) (0MB)
efi: mem111: type=3, attr=0xf, 
range=[0x0000000076214000-0x0000000076250000) (0MB)
efi: mem112: type=4, attr=0xf, 
range=[0x0000000076250000-0x0000000076253000) (0MB)
efi: mem113: type=3, attr=0xf, 
range=[0x0000000076253000-0x0000000076258000) (0MB)
efi: mem114: type=4, attr=0xf, 
range=[0x0000000076258000-0x000000007625b000) (0MB)
efi: mem115: type=3, attr=0xf, 
range=[0x000000007625b000-0x0000000076267000) (0MB)
efi: mem116: type=4, attr=0xf, 
range=[0x0000000076267000-0x00000000762b8000) (0MB)
efi: mem117: type=3, attr=0xf, 
range=[0x00000000762b8000-0x00000000762c2000) (0MB)
efi: mem118: type=5, attr=0x800000000000000f, 
range=[0x00000000762c2000-0x00000000762c4000) (0MB)
efi: mem119: type=3, attr=0xf, 
range=[0x00000000762c4000-0x00000000762d3000) (0MB)
efi: mem120: type=4, attr=0xf, 
range=[0x00000000762d3000-0x00000000762dd000) (0MB)
efi: mem121: type=5, attr=0x800000000000000f, 
range=[0x00000000762dd000-0x00000000762e0000) (0MB)
efi: mem122: type=4, attr=0xf, 
range=[0x00000000762e0000-0x00000000762ec000) (0MB)
efi: mem123: type=5, attr=0x800000000000000f, 
range=[0x00000000762ec000-0x00000000762f2000) (0MB)
efi: mem124: type=3, attr=0xf, 
range=[0x00000000762f2000-0x00000000762f3000) (0MB)
efi: mem125: type=4, attr=0xf, 
range=[0x00000000762f3000-0x00000000762f4000) (0MB)
efi: mem126: type=3, attr=0xf, 
range=[0x00000000762f4000-0x00000000762f7000) (0MB)
efi: mem127: type=5, attr=0x800000000000000f, 
range=[0x00000000762f7000-0x00000000762ff000) (0MB)
efi: mem128: type=3, attr=0xf, 
range=[0x00000000762ff000-0x0000000076307000) (0MB)
efi: mem129: type=2, attr=0xf, 
range=[0x0000000076307000-0x0000000076308000) (0MB)
efi: mem130: type=4, attr=0xf, 
range=[0x0000000076308000-0x000000007630a000) (0MB)
efi: mem131: type=0, attr=0xf, 
range=[0x000000007630a000-0x0000000076313000) (0MB)
efi: mem132: type=6, attr=0x800000000000000f, 
range=[0x0000000076313000-0x0000000076315000) (0MB)
efi: mem133: type=4, attr=0xf, 
range=[0x0000000076315000-0x000000007647f000) (1MB)
efi: mem134: type=3, attr=0xf, 
range=[0x000000007647f000-0x0000000076497000) (0MB)
efi: mem135: type=4, attr=0xf, 
range=[0x0000000076497000-0x000000007649b000) (0MB)
efi: mem136: type=3, attr=0xf, 
range=[0x000000007649b000-0x000000007649d000) (0MB)
efi: mem137: type=4, attr=0xf, 
range=[0x000000007649d000-0x000000007649e000) (0MB)
efi: mem138: type=3, attr=0xf, 
range=[0x000000007649e000-0x00000000764a8000) (0MB)
efi: mem139: type=4, attr=0xf, 
range=[0x00000000764a8000-0x00000000764ba000) (0MB)
efi: mem140: type=3, attr=0xf, 
range=[0x00000000764ba000-0x00000000764bc000) (0MB)
efi: mem141: type=4, attr=0xf, 
range=[0x00000000764bc000-0x000000007652f000) (0MB)
efi: mem142: type=3, attr=0xf, 
range=[0x000000007652f000-0x0000000076534000) (0MB)
efi: mem143: type=4, attr=0xf, 
range=[0x0000000076534000-0x0000000076548000) (0MB)
efi: mem144: type=3, attr=0xf, 
range=[0x0000000076548000-0x0000000076552000) (0MB)
efi: mem145: type=4, attr=0xf, 
range=[0x0000000076552000-0x0000000076554000) (0MB)
efi: mem146: type=3, attr=0xf, 
range=[0x0000000076554000-0x000000007655b000) (0MB)
efi: mem147: type=4, attr=0xf, 
range=[0x000000007655b000-0x0000000076572000) (0MB)
efi: mem148: type=3, attr=0xf, 
range=[0x0000000076572000-0x0000000076573000) (0MB)
efi: mem149: type=4, attr=0xf, 
range=[0x0000000076573000-0x0000000076580000) (0MB)
efi: mem150: type=3, attr=0xf, 
range=[0x0000000076580000-0x0000000076582000) (0MB)
efi: mem151: type=4, attr=0xf, 
range=[0x0000000076582000-0x0000000076584000) (0MB)
efi: mem152: type=3, attr=0xf, 
range=[0x0000000076584000-0x00000000765c1000) (0MB)
efi: mem153: type=4, attr=0xf, 
range=[0x00000000765c1000-0x00000000765c2000) (0MB)
efi: mem154: type=3, attr=0xf, 
range=[0x00000000765c2000-0x00000000765c6000) (0MB)
efi: mem155: type=4, attr=0xf, 
range=[0x00000000765c6000-0x00000000765ce000) (0MB)
efi: mem156: type=3, attr=0xf, 
range=[0x00000000765ce000-0x00000000765d2000) (0MB)
efi: mem157: type=4, attr=0xf, 
range=[0x00000000765d2000-0x00000000765d4000) (0MB)
efi: mem158: type=3, attr=0xf, 
range=[0x00000000765d4000-0x00000000765d9000) (0MB)
efi: mem159: type=4, attr=0xf, 
range=[0x00000000765d9000-0x00000000765da000) (0MB)
efi: mem160: type=3, attr=0xf, 
range=[0x00000000765da000-0x0000000076603000) (0MB)
efi: mem161: type=4, attr=0xf, 
range=[0x0000000076603000-0x0000000076604000) (0MB)
efi: mem162: type=3, attr=0xf, 
range=[0x0000000076604000-0x0000000076611000) (0MB)
efi: mem163: type=4, attr=0xf, 
range=[0x0000000076611000-0x0000000076612000) (0MB)
efi: mem164: type=3, attr=0xf, 
range=[0x0000000076612000-0x0000000076618000) (0MB)
efi: mem165: type=4, attr=0xf, 
range=[0x0000000076618000-0x000000007661a000) (0MB)
efi: mem166: type=3, attr=0xf, 
range=[0x000000007661a000-0x0000000076652000) (0MB)
efi: mem167: type=4, attr=0xf, 
range=[0x0000000076652000-0x0000000076653000) (0MB)
efi: mem168: type=3, attr=0xf, 
range=[0x0000000076653000-0x0000000076664000) (0MB)
efi: mem169: type=4, attr=0xf, 
range=[0x0000000076664000-0x0000000076665000) (0MB)
efi: mem170: type=3, attr=0xf, 
range=[0x0000000076665000-0x0000000076667000) (0MB)
efi: mem171: type=4, attr=0xf, 
range=[0x0000000076667000-0x0000000076668000) (0MB)
efi: mem172: type=3, attr=0xf, 
range=[0x0000000076668000-0x0000000076673000) (0MB)
efi: mem173: type=4, attr=0xf, 
range=[0x0000000076673000-0x0000000076675000) (0MB)
efi: mem174: type=3, attr=0xf, 
range=[0x0000000076675000-0x000000007667d000) (0MB)
efi: mem175: type=4, attr=0xf, 
range=[0x000000007667d000-0x0000000076a7d000) (4MB)
efi: mem176: type=3, attr=0xf, 
range=[0x0000000076a7d000-0x0000000076a82000) (0MB)
efi: mem177: type=4, attr=0xf, 
range=[0x0000000076a82000-0x0000000076a9f000) (0MB)
efi: mem178: type=3, attr=0xf, 
range=[0x0000000076a9f000-0x0000000076aa1000) (0MB)
efi: mem179: type=4, attr=0xf, 
range=[0x0000000076aa1000-0x0000000076ae7000) (0MB)
efi: mem180: type=3, attr=0xf, 
range=[0x0000000076ae7000-0x0000000076aec000) (0MB)
efi: mem181: type=4, attr=0xf, 
range=[0x0000000076aec000-0x0000000076b01000) (0MB)
efi: mem182: type=3, attr=0xf, 
range=[0x0000000076b01000-0x0000000076b23000) (0MB)
efi: mem183: type=4, attr=0xf, 
range=[0x0000000076b23000-0x0000000076b93000) (0MB)
efi: mem184: type=3, attr=0xf, 
range=[0x0000000076b93000-0x0000000076b95000) (0MB)
efi: mem185: type=4, attr=0xf, 
range=[0x0000000076b95000-0x0000000076b96000) (0MB)
efi: mem186: type=3, attr=0xf, 
range=[0x0000000076b96000-0x0000000076ba5000) (0MB)
efi: mem187: type=4, attr=0xf, 
range=[0x0000000076ba5000-0x0000000076ba6000) (0MB)
efi: mem188: type=3, attr=0xf, 
range=[0x0000000076ba6000-0x0000000076ba8000) (0MB)
efi: mem189: type=4, attr=0xf, 
range=[0x0000000076ba8000-0x0000000078b31000) (31MB)
efi: mem190: type=6, attr=0x800000000000000f, 
range=[0x0000000078b31000-0x0000000078b33000) (0MB)
efi: mem191: type=5, attr=0x800000000000000f, 
range=[0x0000000078b33000-0x0000000078b35000) (0MB)
efi: mem192: type=6, attr=0x800000000000000f, 
range=[0x0000000078b35000-0x0000000078b37000) (0MB)
efi: mem193: type=5, attr=0x800000000000000f, 
range=[0x0000000078b37000-0x0000000078b41000) (0MB)
efi: mem194: type=6, attr=0x800000000000000f, 
range=[0x0000000078b41000-0x0000000078b67000) (0MB)
efi: mem195: type=5, attr=0x800000000000000f, 
range=[0x0000000078b67000-0x0000000078b71000) (0MB)
efi: mem196: type=6, attr=0x800000000000000f, 
range=[0x0000000078b71000-0x0000000078b81000) (0MB)
efi: mem197: type=5, attr=0x800000000000000f, 
range=[0x0000000078b81000-0x0000000078bd1000) (0MB)
efi: mem198: type=0, attr=0xf, 
range=[0x0000000078bd1000-0x0000000078bd2000) (0MB)
efi: mem199: type=0, attr=0xf, 
range=[0x0000000078bd2000-0x0000000078bde000) (0MB)
efi: mem200: type=0, attr=0xf, 
range=[0x0000000078bde000-0x0000000078bf6000) (0MB)
efi: mem201: type=0, attr=0xf, 
range=[0x0000000078bf6000-0x0000000078c21000) (0MB)
efi: mem202: type=10, attr=0xf, 
range=[0x0000000078c21000-0x0000000078c7a000) (0MB)
efi: mem203: type=9, attr=0xf, 
range=[0x0000000078c7a000-0x0000000078cda000) (0MB)
efi: mem204: type=10, attr=0xf, 
range=[0x0000000078cda000-0x0000000078cf0000) (0MB)
efi: mem205: type=10, attr=0xf, 
range=[0x0000000078cf0000-0x0000000078d21000) (0MB)
efi: mem206: type=9, attr=0xf, 
range=[0x0000000078d21000-0x0000000078d22000) (0MB)
efi: mem207: type=9, attr=0xf, 
range=[0x0000000078d22000-0x0000000078d41000) (0MB)
efi: mem208: type=4, attr=0xf, 
range=[0x0000000078d41000-0x000000007cda2000) (64MB)
efi: mem209: type=6, attr=0x800000000000000f, 
range=[0x000000007cda2000-0x000000007cda3000) (0MB)
efi: mem210: type=4, attr=0xf, 
range=[0x000000007cda3000-0x000000007cdb5000) (0MB)
efi: mem211: type=6, attr=0x800000000000000f, 
range=[0x000000007cdb5000-0x000000007ce35000) (0MB)
efi: mem212: type=4, attr=0xf, 
range=[0x000000007ce35000-0x000000007f000000) (33MB)
efi: mem213: type=7, attr=0xf, 
range=[0x0000008080000000-0x0000008800000000) (30720MB)
efi: mem214: type=7, attr=0xf, 
range=[0x000000a000000000-0x000000bfff000000) (131056MB)
efi: mem215: type=7, attr=0xf, 
range=[0x000000c000000000-0x000000cfff000000) (65520MB)
efi: mem216: type=7, attr=0xf, 
range=[0x000000e000000000-0x000000efff000000) (65520MB)
efi: mem217: type=11, attr=0x8000000000000001, 
range=[0x0000000080000000-0x0000000090000000) (256MB)
efi: mem218: type=11, attr=0x8000000000000001, 
range=[0x00000000f0000000-0x00000000fc000000) (192MB)
efi: mem219: type=11, attr=0x8000000000000001, 
range=[0x00000000feb00000-0x00000000fec00000) (1MB)
efi: mem220: type=11, attr=0x8000000000000001, 
range=[0x000000ff50000000-0x000000ff53d00000) (61MB)
efi: mem221: type=11, attr=0x8000000000000001, 
range=[0x000000ff53e00000-0x000000ff54000000) (2MB)
efi: mem222: type=11, attr=0x8000000000000001, 
range=[0x000000ff57e00000-0x000000ff58000000) (2MB)
efi: mem223: type=11, attr=0x8000000000000001, 
range=[0x000000ff5be00000-0x000000ff5c000000) (2MB)
efi: mem224: type=11, attr=0x8000000000000001, 
range=[0x000000ff5fe00000-0x000000ff60000000) (2MB)
efi: mem225: type=11, attr=0x8000000000000001, 
range=[0x000000ff80000000-0x000000ff83000000) (48MB)
efi: mem226: type=11, attr=0x8000000000000001, 
range=[0x000000ff84000000-0x000000ff87000000) (48MB)
efi: mem227: type=11, attr=0x8000000000000001, 
range=[0x000000ff88000000-0x000000ff8b000000) (48MB)
efi: mem228: type=11, attr=0x8000000000000001, 
range=[0x000000ff8c000000-0x000000ff8f000000) (48MB)
efi: mem229: type=11, attr=0x8000000000000001, 
range=[0x000000ff90000000-0x000000ff93000000) (48MB)
efi: mem230: type=11, attr=0x8000000000000001, 
range=[0x000000ff94000000-0x000000ff97000000) (48MB)
efi: mem231: type=11, attr=0x8000000000000001, 
range=[0x000000ff98000000-0x000000ff9b000000) (48MB)
efi: mem232: type=11, attr=0x8000000000000001, 
range=[0x000000ff9c000000-0x000000ff9f000000) (48MB)

