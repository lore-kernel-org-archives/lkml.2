Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab2FTHCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:02:32 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34448 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2FTHCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:02:30 -0400
MIME-Version: 1.0
In-Reply-To: <4FDEE4E6.6030205@gmail.com>
References: <1338438844-5022-1-git-send-email-andi@firstfloor.org>
	<1339234803-21106-1-git-send-email-tdmackey@twitter.com>
	<4FDEE4E6.6030205@gmail.com>
Date: Wed, 20 Jun 2012 10:02:29 +0300
X-Google-Sender-Auth: luiCdbpiPeHehdIOdS_IGfpXcZw
Message-ID: <CAOJsxLGcndOEEDzeKJaEiLrwV779R+hv2dPvqBrxbr0FzczpUg@mail.gmail.com>
Subject: Re: [PATCH v5] slab/mempolicy: always use local policy from interrupt context
From: Pekka Enberg <penberg@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: David Mackey <tdmackey@twitter.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, rientjes@google.com,
        Andi Kleen <ak@linux.intel.com>, cl@linux.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 11:20 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> (6/9/12 5:40 AM), David Mackey wrote:
>> From: Andi Kleen<ak@linux.intel.com>
>>
>> From: Andi Kleen<ak@linux.intel.com>
>>
>> slab_node() could access current->mempolicy from interrupt context.
>> However there's a race condition during exit where the mempolicy
>> is first freed and then the pointer zeroed.
>>
>> Using this from interrupts seems bogus anyways. The interrupt
>> will interrupt a random process and therefore get a random
>> mempolicy. Many times, this will be idle's, which noone can change.
>>
>> Just disable this here and always use local for slab
>> from interrupts. I also cleaned up the callers of slab_node a bit
>> which always passed the same argument.
>>
>> I believe the original mempolicy code did that in fact,
>> so it's likely a regression.
>>
>> v2: send version with correct logic
>> v3: simplify. fix typo.
>> Reported-by: Arun Sharma<asharma@fb.com>
>> Cc: penberg@kernel.org
>> Cc: cl@linux.com
>> Signed-off-by: Andi Kleen<ak@linux.intel.com>
>> [tdmackey@twitter.com: Rework control flow based on feedback from
>> cl@linux.com, fix logic, and cleanup current task_struct reference]
>> Signed-off-by: David Mackey<tdmackey@twitter.com>
>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Applied, thanks!
