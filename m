Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2DWQk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:40:59 -0400
Received: from mga10.intel.com ([192.55.52.92]:39549 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751840Ab2DWQk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:40:58 -0400
MIME-Version: 1.0
In-Reply-To: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
References: <1335189109-4871-1-git-send-email-jiang.liu@huawei.com>
Date: Mon, 23 Apr 2012 09:40:55 -0700
Message-ID: <CABE8wwsrPg0br1hEK8eLYNNd+a0r5qsVkpRnVqpvPnz03_OELg@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] enhance dmaengine core to support DMA device hotplug
From: Dan Williams <dan.j.williams@intel.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Keping Chen <chenkeping@huawei.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 6:51 AM, Jiang Liu <liuj97@gmail.com> wrote:
> From: Jiang Liu <liuj97@gmail.com>
>
> This patchset tries to enhance the dmaengine and its clients to support
> hot-removal of DMA devices at runtime, especially for IOAT devices.
>
> When hot-removing IOH (PCI host bridge) on Intel Nehalem/Westmere platform,
> we need to remove all IOAT devices embedded in the IOH. For future Intel
> processor with IIO (Embedded IOH), we need to remove IOAT devices even
> when hot-removing a physical processor. But current dmaengine implementation
> doesn't support hot-removal of IOAT devices at runtime.

Removal of the host bridge means several devices disappear at once.
Is it safe to assume that this action is coordinated by userspace?
I.e. is the kernel given a chance to shut everything down and remove
drivers, or is this a "surprise" unplug?

--
Dan
