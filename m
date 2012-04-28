Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2D1Nck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 09:32:40 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35258 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab2D1Ncg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 09:32:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120427123901.2132.47969.stgit@zurg>
References: <4F91BC8A.9020503@parallels.com> <20120427123901.2132.47969.stgit@zurg>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sat, 28 Apr 2012 09:32:15 -0400
Message-ID: <CAHGf_=riWBO6-Ax0hfSU3hhxr7oXwLwtzJC55yeEpZDOjbqREg@mail.gmail.com>
Subject: Re: [PATCH 1/2] proc: report file/anon bit in /proc/pid/pagemap
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/Documentation/vm/pagemap.txt b/Documentation/vm/pagemap.txt
> index 4600cbe..7587493 100644
> --- a/Documentation/vm/pagemap.txt
> +++ b/Documentation/vm/pagemap.txt
> @@ -16,7 +16,7 @@ There are three components to pagemap:
>     * Bits 0-4   swap type if swapped
>     * Bits 5-54  swap offset if swapped
>     * Bits 55-60 page shift (page size = 1<<page shift)
> -    * Bit  61    reserved for future use
> +    * Bit  61    page is file-page or shared-anon
>     * Bit  62    page swapped
>     * Bit  63    page present

hmm..
Here says, file or shmem.


> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 2d60492..bc3df31 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -700,6 +700,7 @@ struct pagemapread {
>
>  #define PM_PRESENT          PM_STATUS(4LL)
>  #define PM_SWAP             PM_STATUS(2LL)
> +#define PM_FILE             PM_STATUS(1LL)
>  #define PM_NOT_PRESENT      PM_PSHIFT(PAGE_SHIFT)
>  #define PM_END_OF_BUFFER    1

But, this macro says it's file. it seems a bit misleading. ;-)
