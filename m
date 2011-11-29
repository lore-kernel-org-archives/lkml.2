Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab1K2VsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 16:48:18 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56580 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020Ab1K2VsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:48:17 -0500
X-SpamScore: -18
X-BigFish: VS-18(zzbb2dK9371K936eK1432N98dKzz1202hzz8275bhz2dh2a8h668h839h93fh61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4ED5531C.6030104@freescale.com>
Date: Tue, 29 Nov 2011 15:48:12 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: <dedekind1@gmail.com>
CC: Kumar Gala <galak@kernel.crashing.org>,
        Li Yang-R58472 <r58472@freescale.com>, <Artem.Bityutskiy@nokia.com>,
        "b35362@freescale.com>" <b35362@freescale.com>,
        "linux-kernel@vger.kernel.org Kernel" <linux-kernel@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH v2] Integrated Flash Controller support
References: <1320053901-23801-1-git-send-email-b35362@freescale.com>  <CCF7C6DB-437C-4140-894F-2F497AD610DC@kernel.crashing.org>  <8EDB3DC6-63E5-4D5C-BB52-15F32B85C5DD@kernel.crashing.org> <1322602860.2150.10.camel@koala>
In-Reply-To: <1322602860.2150.10.camel@koala>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 03:40 PM, Artem Bityutskiy wrote:
> On Thu, 2011-11-24 at 08:24 -0600, Kumar Gala wrote:
>> On Nov 22, 2011, at 9:41 PM, Kumar Gala wrote:
>>
>>>
>>> On Oct 31, 2011, at 4:38 AM, <b35362@freescale.com> <b35362@freescale.com> wrote:
>>>
>>>> From: Liu Shuo <b35362@freescale.com>
>>>>
>>>> Integrated Flash Controller supports various flashes like NOR, NAND
>>>> and other devices using NOR, NAND and GPCM Machine available on it.
>>>> IFC supports four chip selects.
>>>>
>>>> Signed-off-by: Dipen Dudhat <Dipen.Dudhat@freescale.com>
>>>> Signed-off-by: Scott Wood <scottwood@freescale.com>
>>>> Signed-off-by: Li Yang <leoli@freescale.com>
>>>> Signed-off-by: Liu Shuo <b35362@freescale.com>
>>>> ---
>>>> arch/powerpc/Kconfig               |    4 +
>>>> arch/powerpc/include/asm/fsl_ifc.h |  834 ++++++++++++++++++++++++++++++++++++
>>>> arch/powerpc/sysdev/Makefile       |    1 +
>>>> arch/powerpc/sysdev/fsl_ifc.c      |  322 ++++++++++++++
>>>> 4 files changed, 1161 insertions(+), 0 deletions(-)
>>>> create mode 100644 arch/powerpc/include/asm/fsl_ifc.h
>>>> create mode 100644 arch/powerpc/sysdev/fsl_ifc.c
>>>
>>> Guys,
>>>
>>> How are we handling this patchset since it touches drivers/mtd/nand?
> 
> I do not see it touching MTD from the diffstat above. I am a little bit
> confused why a flash controller is added to
> arch/powerpc/sysdev/fsl_ifc.c ?

It's really a bus controller, with NOR, NAND, and general-purpose modes
settable per chipselect.  The actual NAND driver goes in
drivers/mtd/nand, and is apparently in a separate patch (probably due to
separate maintenance domains).

It's the same situation as arch/powerpc/sysdev/fsl_lbc.c versus
drivers/mtd/nand/fsl_elbc_nand.c and drivers/mtd/nand/fsl_upm.c.

-Scott

