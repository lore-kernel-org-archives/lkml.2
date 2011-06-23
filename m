Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759920Ab1FWR3C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:29:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:50920 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759391Ab1FWR27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:28:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,414,1304319600"; 
   d="scan'208";a="17403532"
From: Andi Kleen <andi@firstfloor.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH v2] xfs: Silence bounds checking compiler warning
References: <4E037001.8090306__42924.0493024283$1308849791$gmane$org@gmail.com>
Date: Thu, 23 Jun 2011 10:27:26 -0700
In-Reply-To: <4E037001.8090306__42924.0493024283$1308849791$gmane$org@gmail.com>
	(Maarten Lankhorst's message of "Thu, 23 Jun 2011 18:55:29 +0200")
Message-ID: <m2boxocvb5.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maarten Lankhorst <m.b.lankhorst@gmail.com> writes:

> gcc with -Warray-bounds generates a false positive on this
> since xfs defines the struct with u8 name[1]; to be able to
> add a tag at the end.

A better way would be to define it as name[0]. Then the compiler
would know it's a VLA. You may need to check noone relies on
the one byte though.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
