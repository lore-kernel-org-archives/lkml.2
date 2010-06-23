Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0FWNKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 09:10:17 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:54093 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751217Ab0FWNKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 09:10:13 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jun 2010 09:10:13 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAPKhIUxLd/sX/2dsb2JhbAAHgxbNVJEfgSaDBXAEhks
X-IronPort-AV: E=Sophos;i="4.53,466,1272859200"; 
   d="scan'208";a="68704499"
Message-ID: <4C22055E.5060705@teksavvy.com>
Date: Wed, 23 Jun 2010 09:00:14 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Robert Hancock <hancockrwd@gmail.com>
CC: Catalin Marinas <catalin.marinas@arm.com>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Colin Tuckley <colin.tuckley@arm.com>, Jeff Garzik <jeff@garzik.org>,
       linux-arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] sata_sil24: Use memory barriers before issuing commands
References: <20100610160212.18091.29856.stgit@e102109-lin.cambridge.arm.com>	 <4C110EDD.2010409@kernel.org> <1276187002.24535.88.camel@e102109-lin.cambridge.arm.com> <4C118697.9090305@gmail.com>
In-Reply-To: <4C118697.9090305@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/10 08:43 PM, Robert Hancock wrote:
..
> My memory is fuzzy but I thought this came up before on PPC and I also
> thought the conclusion was that the platform code (for writel, etc.)
> should enforce ordering of MMIO accesses with respect to normal RAM
> accesses. (Or maybe it was just MMIO accesses with respect to each
> other?) I don't think the answer to that question has been clearly
> documented anywhere, which is somewhat unfortunate.
..

Different problem.  That discussion was for PIO reads into the page cache,
and ensuring coherency from all of that.

Whereas this patch is just ordinary low-level chipset programming,
and ensuring the descriptors are visible before issuing the "go" command.
