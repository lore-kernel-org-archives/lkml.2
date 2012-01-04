Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab2ADCoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 21:44:54 -0500
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:49687 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753880Ab2ADCoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 21:44:22 -0500
MIME-Version: 1.0
In-Reply-To: <20120103203357.GD17472@phenom.dumpdata.com>
References: <CAJULonj9rFDKNCzpEXj2r3XjkYojy-CGYpVQ1RF8SxwLVrXqAA@mail.gmail.com>
	<20120103203357.GD17472@phenom.dumpdata.com>
Date: Wed, 4 Jan 2012 10:44:11 +0800
Message-ID: <CAJULongKix3QXmcoUcraQxCyLN0wz6oe6p5Efg2A7S_r3nO6Fg@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=E3=80=90Question=E3=80=91Whether_it=27s_legal_to_enable_same_?=
	=?UTF-8?Q?physical_DMA_memory_mapped_for_different_NIC_device=3F?=
From: Yanfei Wang <backyes@mail.ustc.edu.cn>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-CM-TRANSID: yia_0ZCbbwf9vANPQEIPAA--.29699S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kw1xCry3Gw4UGFy7ZF1rtFb_yoW8Cr4fpF
	WkXFy3Kwn5JFyvyr47Ww43Za1UAa18GF4fK345Cw109w45WFySvrZ2vrZ5uFy3WFyjga4S
	qFsrGw15GFW5Za7anT9S1TB71UUUUU7v73VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UU
	U0E7k042IEc7kJM7k042IE4IxYO2xFxVAqjxCEw4Av424lb7IF0VCFvT92vfvE14ylb7Iv
	0xC_Cr1lb4IE77IF4wAFxVCF77xC6IxKo4kEV4yl1I0EscIYIxCEI4klw4CSwwAajcAI6x
	AYOVAKp-VFvr4ln7xl0VCFbcvEwTZvWa45M2kK64x0aVW7GwIE548m6rI_Jw1UWr17M2kK
	64x0aVW7GwIE548m6rv_Jw1UWr17M2vj6xkI62vS6c8GOVWUtr1rJFyl57IF6xkI12xvs2
	x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26rWY6Fy7
	McIj6I8E87Iv67AKxVW8Jr0_Cr1UMxkFs20EbsIEYx1l42xK82IYc2Ij64vIr41l42xK82
	IY6x8ErcxFaVAv8VW8WwCFI7vE84CIb48I67vvx24l4IxY624lx4CE17CEb7AF67AKxVWU
	AVWUtwCIc40Y0x0EwIxGrbIYCTnIWIevJa73UjIFyTuYvjxUxHUqUUUUU
X-CM-SenderInfo: 5edfy51hv6zt1loo32lwfovvfxof0/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 4, 2012 at 4:33 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Wed, Dec 07, 2011 at 10:16:40PM +0800, ustc.mail wrote:
>> Dear all,
>>
>> In NIC driver, to eliminate the  overhead of dma_map_single() for DMA
>> packet data,  we have statically allocated huge DMA memory buffer ring
>> at once instead of calling dma_map_single() per packet.  Considering
>> to further reduce the copy overhead between different NIC(port) ring
>> while forwarding, one packet from a input NIC(port) will be
>> transferred to output NIC(port) with no any copy action.
>>
>> To satisfy this requirement, the packet memory should be mapped into
>> input port and unmapped when leaving input port, then mapped into
>> output port and unmapped later.
>>
>> Whether it's legal to map the same DMA memory into input and output
>> port simultaneously? If it's not, then the zero-copy for packet
>> forwarding is not feasible?
>>
>
> Did you ever a get a response about this?
No.
>
> Is the output/input port on a seperate device function? Or is it
> just a specific MMIO BAR in your PCI device?
>
Platform: x86, intel nehalem 8Core NUMA, linux 2.6.39, 10G
82599NIC(two ports per NIC card);
Function: Forwarding packets between different ports.
Targets: Forwarding packets with Zero-Overhead, despite other obstacles.

--Yanfei
>> Hope PCI expert to post your suggestion.
>>
>> Thanks!
>>
>> --Yanfei
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

