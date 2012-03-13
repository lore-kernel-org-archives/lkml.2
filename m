Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789Ab2CMGYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:24:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58405 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab2CMGYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:24:12 -0400
MIME-Version: 1.0
In-Reply-To: <1331488109-13466-3-git-send-email-jiang.liu@huawei.com>
References: <1331488109-13466-1-git-send-email-jiang.liu@huawei.com>
	<1331488109-13466-3-git-send-email-jiang.liu@huawei.com>
Date: Mon, 12 Mar 2012 23:24:11 -0700
X-Google-Sender-Auth: fzm4wR4pH5Z-EqmUcJJYzOQq0Bs
Message-ID: <CAE9FiQVRMBHN+QbFpVv4j2xPfco2X0bt9OzzcSE-BrrDY4Oqgg@mail.gmail.com>
Subject: Re: [PATCH 2/5] Correctly clean up pci root buses in function pci_remove_bus()
From: Yinghai Lu <yinghai@kernel.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, chenkeping@huawei.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 10:48 AM, Jiang Liu <liuj97@gmail.com> wrote:
> The function pci_create_root_bus() allocates the pci bus structure,
> registers the bus device and creates the legacy files for a pci root
> bus, but returns without setting the is_added flag. The is_added flag
> for a pci root bus will be set by function pci_scan_child_bus().

> If a pci root bus is destroyed before calling pci_scan_child_bus(),
> the is_added flag will not be set.

how that can be met?

Do we have pci_remove_rescan_mutex around them?

Yinghai
