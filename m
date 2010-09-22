Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0IVUjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 16:39:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:57845 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab0IVUjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 16:39:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,219,1283756400"; 
   d="scan'208";a="609431213"
Message-ID: <4C9A698B.90806@linux.intel.com>
Date: Wed, 22 Sep 2010 22:39:39 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>,
        David Miller <davem@davemloft.net>,
        Matthew Wilcox <willy@linux.intel.com>,
        Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 2/2] siw: Add support for CRC32C offload instruction using
 libcrypto crc32c-intel
References: <1285187425-10950-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1285187425-10950-1-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 9/22/2010 10:30 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger<nab@linux-iscsi.org>
>
> This patch updates siw_create_qp() to check for the CONFIG_X86 + cpu_has_xmm4_2
> dependent use of the CRC32C instruction offload using libcrypto crc32c-intel.ko.
> This patch will by default use crc32c-intel when available, and fall back to the
> legacy slicing by 1x libcrypto crc32c.ko code when the instruction offload is not
> availabe.

I don't think every caller should handle checks like this. The crypto 
layer should load the right driver
instead and provide the best driver under a generic algorithm name.

Need CPUID module auto probing. I have an older patch that needs some fixes.

-Andi

