Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2ACUfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:35:47 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:47356 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2ACUfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:35:45 -0500
Date: Tue, 3 Jan 2012 15:33:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "ustc.mail" <backyes@mail.ustc.edu.cn>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: =?utf-8?B?44CQUXVlc3Rpb27jgJFXaGV0aGVy?=
 =?utf-8?Q?_it's_legal_to_enabl?= =?utf-8?Q?e?= same physical DMA memory
 mapped for different NIC device?
Message-ID: <20120103203357.GD17472@phenom.dumpdata.com>
References: <CAJULonj9rFDKNCzpEXj2r3XjkYojy-CGYpVQ1RF8SxwLVrXqAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJULonj9rFDKNCzpEXj2r3XjkYojy-CGYpVQ1RF8SxwLVrXqAA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090203.4F036694.00CA,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 10:16:40PM +0800, ustc.mail wrote:
> Dear all,
> 
> In NIC driver, to eliminate the  overhead of dma_map_single() for DMA
> packet data,  we have statically allocated huge DMA memory buffer ring
> at once instead of calling dma_map_single() per packet.  Considering
> to further reduce the copy overhead between different NIC(port) ring
> while forwarding, one packet from a input NIC(port) will be
> transferred to output NIC(port) with no any copy action.
> 
> To satisfy this requirement, the packet memory should be mapped into
> input port and unmapped when leaving input port, then mapped into
> output port and unmapped later.
> 
> Whether it's legal to map the same DMA memory into input and output
> port simultaneously? If it's not, then the zero-copy for packet
> forwarding is not feasible?
> 

Did you ever a get a response about this?

Is the output/input port on a seperate device function? Or is it
just a specific MMIO BAR in your PCI device?

> Hope PCI expert to post your suggestion.
> 
> Thanks!
> 
> --Yanfei
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
