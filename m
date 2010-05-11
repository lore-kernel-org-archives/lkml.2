Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0EKTBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:01:38 -0400
Received: from smtp132.mail.ukl.yahoo.com ([77.238.184.63]:43348 "HELO
	smtp132.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751171Ab0EKTBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:01:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.es;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=5ZVMxZW6Kbs3HuDf6YN5HtypaUwkoVaS/aq+EXjL0cz/H9beAn5NwykUp6zjW9mpxcIJQIfhX+ELnK/AF1FVEoc++iFWQC0d8GaAxBdl/Wsmv7e20UsVn1kV7BFIxlZr85TudFJJ4kh2vqDiRIRCe3G0auuFXQoHCbCjVTilHj4=  ;
X-Yahoo-SMTP: czee06uswBAtfIYshc.kP27UlfEXaxwWNSjJ
X-YMail-OSG: LZXmoZwVM1kSs0Ow3O19aUXAl11Y9FBBt86LLoEqYPzfqTcp.yfrBdQaHIjFBOWYTLyj3WFXTNYtZ_owb2KahlzGcxse2wnohktIK0eSWbpTyo_o11gF8aK_t77XIvP_U8UM8n1LaM2e5Tk_2Ot1fA_sMTrhmsdHqFgWydyV.vDyDYF1V9YplS8ND7Q_BQtBFMRfjRQB9AxzzrvKtTdL5Yl.gph4ULgA35RVsOOhKc9EJm2p8LjY2nenSk1sJiHF
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4BE9A989.5020808@yahoo.es>
Date: Tue, 11 May 2010 21:01:29 +0200
From: Albert Herranz <albert_herranz@yahoo.es>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: chrisw@sous-sol.org, jeremy@goop.org, Ian.Campbell@eu.citrix.com,
       linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, dwmw2@infradead.org
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions	visible
 in the header file.
References: <1273592353-23224-1-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-2-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-3-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-4-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-5-git-send-email-konrad.wilk@oracle.com> <1273592353-23224-6-git-send-email-konrad.wilk@oracle.com> <4BE9A1C0.3090505@yahoo.es> <20100511184657.GA23464@phenom.dumpdata.com>
In-Reply-To: <20100511184657.GA23464@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk wrote:
>>> +extern void *swiotlb_tbl_map_single(struct device *hwdev, phys_addr_t phys,
>>> +				    u64 tbl_dma_addr, size_t size,
>>> +				    enum dma_data_direction dir);
>>> +
>> The phys and tbl_dma_addr arguments in the function prototype are swapped compared to the function definition in patch 1/6.
> 
> Duh! Thanks for spotting that. Here is a repost of this patch (I've 
> updated the git tree with the one below):
> 

Thanks. That was fast :)

One more thing. Shouldn't be more appropriate to make tbl_dma_addr a dma_addr_t instead of a u64?
For example, in my case I'm currently using the swiotlb code to overcome some DMA limitations in a 32-bit PowerPC platform.
In this scenario the dma_addr_t type is defined either as a u64 for 64-bit PowerPC or as a u32 for 32-bit PowerPC.

Cheers,
Albert

