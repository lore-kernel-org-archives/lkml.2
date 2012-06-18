Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2FRIU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:20:59 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55696 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2FRIU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:20:57 -0400
Message-ID: <4FDEE4E6.6030205@gmail.com>
Date: Mon, 18 Jun 2012 04:20:54 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Mackey <tdmackey@twitter.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rientjes@google.com,
        Andi Kleen <ak@linux.intel.com>, penberg@kernel.org, cl@linux.com,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH v5] slab/mempolicy: always use local policy from interrupt
 context
References: <1338438844-5022-1-git-send-email-andi@firstfloor.org> <1339234803-21106-1-git-send-email-tdmackey@twitter.com>
In-Reply-To: <1339234803-21106-1-git-send-email-tdmackey@twitter.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(6/9/12 5:40 AM), David Mackey wrote:
> From: Andi Kleen<ak@linux.intel.com>
> 
> From: Andi Kleen<ak@linux.intel.com>
> 
> slab_node() could access current->mempolicy from interrupt context.
> However there's a race condition during exit where the mempolicy
> is first freed and then the pointer zeroed.
> 
> Using this from interrupts seems bogus anyways. The interrupt
> will interrupt a random process and therefore get a random
> mempolicy. Many times, this will be idle's, which noone can change.
> 
> Just disable this here and always use local for slab
> from interrupts. I also cleaned up the callers of slab_node a bit
> which always passed the same argument.
> 
> I believe the original mempolicy code did that in fact,
> so it's likely a regression.
> 
> v2: send version with correct logic
> v3: simplify. fix typo.
> Reported-by: Arun Sharma<asharma@fb.com>
> Cc: penberg@kernel.org
> Cc: cl@linux.com
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
> [tdmackey@twitter.com: Rework control flow based on feedback from
> cl@linux.com, fix logic, and cleanup current task_struct reference]
> Signed-off-by: David Mackey<tdmackey@twitter.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




