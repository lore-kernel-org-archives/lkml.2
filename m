Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790Ab2EIOIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:08:21 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:11150
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757918Ab2EIOIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:08:20 -0400
X-IronPort-AV: E=Sophos;i="4.75,557,1330902000"; 
   d="scan'208";a="143204670"
Message-ID: <4FAA7A51.6050504@inria.fr>
Date: Wed, 09 May 2012 16:08:17 +0200
From: Brice Goglin <Brice.Goglin@inria.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Zhouping Liu <zliu@redhat.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: mm: move_pages syscall can't return ENOENT when pages are not
 present
References: <85e08d38-234a-4bc6-8c4f-6c92b50dc9b1@zmail13.collab.prod.int.phx2.redhat.com>
In-Reply-To: <85e08d38-234a-4bc6-8c4f-6c92b50dc9b1@zmail13.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 09/05/2012 10:58, Zhouping Liu a écrit :
> hi, all
>
> Recently, I found an error in move_pages syscall:
>
> depending on move_pages(2), when page is not present,
> it should fail with ENOENT, in fact, it's ok without
> any errno.
>
> the following reproducer can easily reproduce
> the issue, suggest you get more details by strace.
> inside reproducer, I try to move a non-exist page from
> node 1 to node 0.
>

If I understand correctly, 3 pages should migrate properly but the last
one cannot migrate because it's not present. In this case, move_pages
returns success. -ENOENT is set in the status array, not in the return
value/errno.

In the past, if *all* pages failed to migrate, move_pages would return
ENOENT instead of success, but the behavior was inconsistent so I
changed that in commit e78bbfa8262424417a29349a8064a535053912b9 as
Wanlong Gao said. But that should not matter here since 3 pages out of 4
are successfully migrated from what I understand.

The manpage should be updated (remove ENOENT from the ERRORS section,
but keep it in the "Page states in the status array" section).

Brice

