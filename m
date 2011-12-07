Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab1LGOQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:16:55 -0500
Received: from smtp2.ustc.edu.cn ([202.38.64.46]:36745 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755798Ab1LGOQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:16:52 -0500
MIME-Version: 1.0
Date: Wed, 7 Dec 2011 22:16:40 +0800
Message-ID: <CAJULonj9rFDKNCzpEXj2r3XjkYojy-CGYpVQ1RF8SxwLVrXqAA@mail.gmail.com>
Subject: =?UTF-8?Q?=E3=80=90Question=E3=80=91Whether_it=27s_legal_to_enable_same_phys?=
	=?UTF-8?Q?ical_DMA_memory_mapped_for_different_NIC_device=3F?=
From: "ustc.mail" <backyes@mail.ustc.edu.cn>
To: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-CM-TRANSID: yia_0ZD7KwhJdd9OwLmdBg--.18602S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JFW7uw1UXr4ftF4UJrW5ZFb_yoW3ZrXE9w
	s5Xr1Ut39ruwnxKF1rtFW5CF429rZ7Zwn0qr43uwnxK34rJFZxXwn29rWfZF4Syr1Yqr98
	G3yIvrWFyF12vjkaLaAFLSUrUUUUjbIjqfuFe4nvWSU5nxnvy29KBjDU0xBIdaVrnRJUUU
	x0b7IF0VCYb41lb7IF0VCFI7km07C26c804VAKzcIF0wAYjxAI6xZILanIXVAFwwAYjsxI
	4VWDJwAYFVCjjxCrM7C26xCjj4IEI4klw4CSwwAFxVCaYxvI4VCIwcAKzIAtM2k0o2IE47
	km649EmfZxGwAajcAI6xAYOVAKp-VFvryl57IF6xkI12xvs2x26I8E6xACxx1l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj64x0Y40En7xvr7AKxVWUJVW8JwAv7VC0I7IYx2IY67AKxV
	WrXVW3AwAv7VC2z280aVAFwI0_GcC_XcWlc7Ca8VAYaVAv7wCF04k20xvY0x0EwIxGrwCF
	04k20xvE74AGY7Cv6cx26r4rMxCIbVA2zIxYr2IEbsI20wCFI7vE0wC2zVAF1VAY17CE14
	v26r1Y6r17YxBIdaVFxhVjvjDU0xZFpf9x07j-DGOUUUUU=
X-CM-SenderInfo: 5edfy51hv6zt1loo32lwfovvfxof0/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

In NIC driver, to eliminate the  overhead of dma_map_single() for DMA
packet data,  we have statically allocated huge DMA memory buffer ring
at once instead of calling dma_map_single() per packet.  Considering
to further reduce the copy overhead between different NIC(port) ring
while forwarding, one packet from a input NIC(port) will be
transferred to output NIC(port) with no any copy action.

To satisfy this requirement, the packet memory should be mapped into
input port and unmapped when leaving input port, then mapped into
output port and unmapped later.

Whether it's legal to map the same DMA memory into input and output
port simultaneously? If it's not, then the zero-copy for packet
forwarding is not feasible?

Hope PCI expert to post your suggestion.

Thanks!

--Yanfei

