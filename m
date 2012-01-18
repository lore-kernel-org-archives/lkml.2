Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab2ARAcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 19:32:52 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17275 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab2ARAcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 19:32:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 17 Jan 2012 16:32:50 -0800
From: Robert Morell <rmorell@nvidia.com>
To: linux-kernel@vger.kernel.org, sumit.semwal@linaro.org, airlied@linux.ie
Cc: dri-devel@lists.freedesktop.org
Subject: Expanding the use of DMA buffers in 3.3
Date: Tue, 17 Jan 2012 16:08:16 -0800
Message-Id: <1326845297-6233-1-git-send-email-rmorell@nvidia.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
References: <alpine.DEB.2.00.1201061458020.18430@skynet.skynet.ie>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DMA buffer infrastructure (dma-buf) currently exposes its interface
with EXPORT_SYMBOL_GPL.  The documentation for EXPORT_SYMBOL_GPL says:
    "It implies that the function is considered an internal
    implementation issue, and not really an interface."
This interface is clearly not just an "implementation issue" but an
interface to be used across drivers/subsystems, so I think it makes
sense for it to use EXPORT_SYMBOL instead.

Work on dma-buf was originally started with the goal of unifying several
competing "memory management" systems developed with different ARM SoCs
in mind.  It would be unfortunate if restricting its use to only
GPL-licensed modules caused dma-buf adoption to be limited.

For convenience, I'll send the trivial patch to implement this change.
I'd like to see this in the first release with dma-buf in 3.3.

Thanks,
Robert


