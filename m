Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759464Ab1JGCCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 22:02:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:27328 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab1JGCCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 22:02:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,499,1312182000"; 
   d="scan'208";a="24050872"
From: Andi Kleen <andi@firstfloor.org>
To: "hpanvin\@gmail.com" <hpa@zytor.com>
Cc: Josh Stone <jistone@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] x86: Make variable_test_bit reference all of *addr
References: <1317945508-19575-1-git-send-email-jistone@redhat.com>
	<990b8719-066b-4e1d-892f-6a3ea4241fb2@email.android.com>
Date: Thu, 06 Oct 2011 19:02:20 -0700
In-Reply-To: <990b8719-066b-4e1d-892f-6a3ea4241fb2@email.android.com>
	(hpa@zytor.com's message of "Thu, 06 Oct 2011 18:37:27 -0700")
Message-ID: <m2d3e936fn.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"hpanvin@gmail.com" <hpa@zytor.com> writes:


> This is concerning... the kernel relies heavily on asm volatile being a universal memory consumer.  If that is suddenly broken, we are f*** in many, many, MANY places in the kernel all of a sudden!

I don't think that's true. We generally add "memory" clobbers for this
purpose. asm volatile just means "don't move" 

Just this one doesn't have it for unknown reasons (someone overoptimizing?)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
