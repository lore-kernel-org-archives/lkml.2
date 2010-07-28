Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0G1RHh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 13:07:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:37858 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0G1RHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 13:07:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,275,1278313200"; 
   d="scan'208";a="590567954"
Message-ID: <4C5063D4.4070108@linux.intel.com>
Date: Wed, 28 Jul 2010 19:07:32 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] x86: mce: fix error handling
References: <1280335185-23265-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1280335185-23265-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 7/28/2010 6:39 PM, Kulikov Vasiliy wrote:
> mcheck_init_device() poorly handles errors. If any request fails
> unregister and free everything.

Actually these are at early boot time and only contain memory errors,
and if you run out of memory at this stage the system is usually
dead in the water anyways. The best you can do at this stage
is panicing, but silently returning from the the init function doesn't
help anyone. But someone else will likely panic anyways.

e.g. boot time allocations of cpu masks generally do not check for memory
failures and I think that's ok, not a bug.

Your patch would be good if the driver was modular, but it isn't.

-Andi

