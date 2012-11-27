Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab2K0VIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 16:08:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:27877 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab2K0VIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 16:08:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,174,1355126400"; 
   d="scan'208";a="248070105"
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
        Andi Kleen <andi.kleen@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm, soft offline: split thp at the beginning of soft_offline_page()
References: <1354050331-26844-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Tue, 27 Nov 2012 13:08:38 -0800
In-Reply-To: <1354050331-26844-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	(Naoya Horiguchi's message of "Tue, 27 Nov 2012 16:05:31 -0500")
Message-ID: <m2k3t6hhyh.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> When we try to soft-offline a thp tail page, put_page() is called on the
> tail page unthinkingly and VM_BUG_ON is triggered in put_compound_page().
> This patch splits thp before going into the main body of soft-offlining.

Looks good.

>
> The interface of soft-offlining is open for userspace, so this bug can
> lead to DoS attack and should be fixed immedately.

The interface is root only and root can do everything anyways, so it's
not really a security issue.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
