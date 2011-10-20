Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1JTV2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:28:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:18795 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1JTV2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:28:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,381,1315206000"; 
   d="scan'208";a="75936183"
From: Andi Kleen <andi@firstfloor.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai.lu@oracle.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Exclude E820_RESERVED regions and memory holes above 4 GB from direct mapping.
References: <1319145326-13902-1-git-send-email-jacob.shin@amd.com>
Date: Thu, 20 Oct 2011 14:28:20 -0700
In-Reply-To: <1319145326-13902-1-git-send-email-jacob.shin@amd.com> (Jacob
	Shin's message of "Thu, 20 Oct 2011 16:15:26 -0500")
Message-ID: <m2sjmnxsi3.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob Shin <jacob.shin@amd.com> writes:

> On systems with very large memory (1 TB in our case), BIOS may report a
> reserved region or a hole in the E820 map, even above the 4 GB range. Exclude
> these from the direct mapping.

This doesn't make much sense.  Holes above 4GB are completely legal.

If you need to workaround a specific broken BIOS you would need a quirk
only matching that system, with a suitable "BIOS is broken" message.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
