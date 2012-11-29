Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2K2SpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 13:45:12 -0500
Received: from mga03.intel.com ([143.182.124.21]:9515 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab2K2SpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 13:45:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,186,1355126400"; 
   d="scan'208";a="174095522"
From: Andi Kleen <andi@firstfloor.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
	<1354121029-1376-23-git-send-email-koverstreet@google.com>
Date: Thu, 29 Nov 2012 10:45:04 -0800
In-Reply-To: <1354121029-1376-23-git-send-email-koverstreet@google.com> (Kent
	Overstreet's message of "Wed, 28 Nov 2012 08:43:46 -0800")
Message-ID: <m28v9kgsen.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> This implements a refcount with similar semantics to
> atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> but dynamically switches to per cpu refcounting when the rate of
> gets/puts becomes too high.

This will only work if you put on the same CPU as you get, right?
In this case I would rather use RCU. It's clearly unusable for anything 
blocking (or not get_cpu) Normally RCU already handles the "ref count for short non
blocking case"

Is that really true for AIO? It seems dubious.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only
