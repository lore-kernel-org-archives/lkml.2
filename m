Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab0K3WYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:24:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56756 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872Ab0K3WY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:24:28 -0500
Date: Tue, 30 Nov 2010 14:23:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/3] Move zone_reclaim() outside of CONFIG_NUMA
Message-Id: <20101130142338.5e845880.akpm@linux-foundation.org>
In-Reply-To: <20101130101506.17475.34536.stgit@localhost6.localdomain6>
References: <20101130101126.17475.18729.stgit@localhost6.localdomain6>
	<20101130101506.17475.34536.stgit@localhost6.localdomain6>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Nov 2010 15:45:12 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> This patch moves zone_reclaim and associated helpers
> outside CONFIG_NUMA. This infrastructure is reused
> in the patches for page cache control that follow.
> 

Thereby adding a nice dollop of bloat to everyone's kernel.  I don't
think that is justifiable given that the audience for this feature is
about eight people :(

How's about CONFIG_UNMAPPED_PAGECACHE_CONTROL?

Also this patch instantiates sysctl_min_unmapped_ratio and
sysctl_min_slab_ratio on non-NUMA builds but fails to make those
tunables actually tunable in procfs.  Changes to sysctl.c are
needed.

> Reviewed-by: Christoph Lameter <cl@linux.com>

More careful reviewers, please.
