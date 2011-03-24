Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933370Ab1CXSj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:39:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:46704 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757014Ab1CXSj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:39:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,238,1299484800"; 
   d="scan'208";a="901397665"
From: Andi Kleen <andi@firstfloor.org>
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@novell.com>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock if possible
References: <201103241026.01624.knikanth@suse.de>
Date: Thu, 24 Mar 2011 11:38:28 -0700
In-Reply-To: <201103241026.01624.knikanth@suse.de> (Nikanth Karthikesan's
	message of "Thu, 24 Mar 2011 10:26:01 +0530")
Message-ID: <m2tyestlcr.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikanth Karthikesan <knikanth@suse.de> writes:

> On x86_64 SMP with lots of CPU atomic instructions which assert the LOCK #
> signal can stall other CPUs. And as the number of cores increase this penalty

This description is very wrong. No modern CPU still has a LOCK # signal
or does global stalls for LOCK.

Do you actually have any data this is a problem and how much
difference the patch makes?

Also there's the missing barrier now of course.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
