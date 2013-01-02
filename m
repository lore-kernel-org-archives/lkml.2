Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3ABRZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 12:25:01 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53071 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3ABRY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 12:24:59 -0500
MIME-Version: 1.0
In-Reply-To: <0000013bfbfbb293-ccc455ed-2db6-46e2-8362-dc418bae0def-000000@email.amazonses.com>
References: <alpine.LNX.2.00.1301020153090.18049@eggly.anvils> <0000013bfbfbb293-ccc455ed-2db6-46e2-8362-dc418bae0def-000000@email.amazonses.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Jan 2013 09:24:37 -0800
X-Google-Sender-Auth: Bd5rna0ecx6w7rDCmrPJu-vcFec
Message-ID: <CA+55aFyH63agfbf+pYNRGHaprPqAJF=F19GR6ASP_RhoyDGLdA@mail.gmail.com>
Subject: Re: [PATCH 1/2] tmpfs mempolicy: fix /proc/mounts corrupting memory
To: Christoph Lameter <cl@linux.com>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 7:57 AM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 2 Jan 2013, Hugh Dickins wrote:
>
>> @@ -2796,10 +2787,7 @@ int mpol_to_str(char *buffer, int maxlen
>>       case MPOL_BIND:
>>               /* Fall through */
>>       case MPOL_INTERLEAVE:
>> -             if (no_context)
>> -                     nodes = pol->w.user_nodemask;
>> -             else
>> -                     nodes = pol->v.nodes;
>> +             nodes = pol->v.nodes;
>>               break;
>>
>
> no_context was always true. Why is the code from the false branch kept?

no_context is zero in the caller in fs/proc/task_mmu.c, and one in the
mm/shmem.c caller. So it's not always true (for mpol_parse_str() there
is only one caller, and it's always true as Hugh said).

Anyway, I do not know why Hugh took the true case, but I don't really
imagine that it matters. So I'll take these two patches, but it would
be good if you double-checked this, Hugh.

Hugh?

                   Linus
