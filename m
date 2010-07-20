Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761148Ab0GTSPf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 14:15:35 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64528 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637Ab0GTSPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 14:15:33 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6049"; a="48068738"
Subject: Re: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
From: Daniel Walker <dwalker@codeaurora.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-msm@vger.kernel.org
In-Reply-To: <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
	 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
	 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Jul 2010 11:15:24 -0700
Message-ID: <1279649724.26765.23.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 17:51 +0200, Michal Nazarewicz wrote:
> +** Use cases
> +
> +    Lets analyse some imaginary system that uses the CMA to see how
> +    the framework can be used and configured.
> +
> +
> +    We have a platform with a hardware video decoder and a camera
> each
> +    needing 20 MiB of memory in worst case.  Our system is written in
> +    such a way though that the two devices are never used at the same
> +    time and memory for them may be shared.  In such a system the
> +    following two command line arguments would be used:
> +
> +        cma=r=20M cma_map=video,camera=r 

This seems inelegant to me.. It seems like these should be connected
with the drivers themselves vs. doing it on the command like for
everything. You could have the video driver declare it needs 20megs, and
the the camera does the same but both indicate it's shared ..

If you have this disconnected from the drivers it will just cause
confusion, since few will know what these parameters should be for a
given driver set. It needs to be embedded in the kernel.

Daniel

-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

