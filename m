Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab0HNPZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 11:25:59 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:57333 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751132Ab0HNPZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 11:25:58 -0400
Message-ID: <4C66B580.5060606@cyconix.com>
Date: Sat, 14 Aug 2010 16:25:52 +0100
From: Evan Lavelle <sa212+lkml@cyconix.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Driver: PCIe: 'pci_map_sg' returning invalid bus address?
References: <4C5002AD.6070206@cyconix.com>
In-Reply-To: <4C5002AD.6070206@cyconix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks guys. I had to get this working quickly so I just stuck with my 
bounce buffer code. I'm not sure that it's technically a 'bounce 
buffer'; it just so happens that 'pci_alloc_consistent' returns an 
address in the low 32 bits. This may stop working if the user installs 
more than 4Gig of memory but I can live with that for now. Performance 
isn't great (~110Mbytes/s on 4-channel PCIe) but it's good enough.

It's disappointing that LDD didn't have anything to say about this; it's 
pretty fundamental to DMA on x86_32 and PAE.

Thanks -

Evan
