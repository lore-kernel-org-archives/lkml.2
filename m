Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695Ab2HaIjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 04:39:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43741 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2HaIjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 04:39:49 -0400
MIME-Version: 1.0
In-Reply-To: <5040775C.3070205@intel.com>
References: <1342139517-3451-1-git-send-email-walken@google.com>
	<1342139517-3451-8-git-send-email-walken@google.com>
	<50406F60.5040707@intel.com>
	<CANN689EBA6yPk3pS-yXZ1-ticG7eU3mY1mWMWp2S3xhJ73ODFA@mail.gmail.com>
	<20120831011541.ddf8ed78.akpm@linux-foundation.org>
	<5040775C.3070205@intel.com>
Date: Fri, 31 Aug 2012 01:39:48 -0700
Message-ID: <CANN689E8u-rx08NMG3JRaay1BdM=VTe6nzE_FfcPSFSShbL=9A@mail.gmail.com>
Subject: Re: [PATCH v2 07/12] rbtree: adjust root color in rb_insert_color()
 only when necessary
From: Michel Lespinasse <walken@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Shishkin, Alexander" <alexander.shishkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, acme@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 1:35 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 31/08/12 11:15, Andrew Morton wrote:
>> On Fri, 31 Aug 2012 01:07:24 -0700 Michel Lespinasse <walken@google.com> wrote:
>>> I thought Andrew had a patch
>>> rbtree-adjust-root-color-in-rb_insert_color-only-when-necessary-fix-perf-compilation
>>> that fixed this though a Makefile change ?
>>
>> Yup.  But it's unclear why we should include the header via the cc
>> command line?
>
> Dunno
>
> AFAICS tools/perf/util/include/linux is for fixing up the
> differences between kernel headers and exported kernel headers.
> Hence my change:
>
> diff --git a/tools/perf/util/include/linux/rbtree.h b/tools/perf/util/include/linux/rbtree.h
> index 7a243a1..2a030c5 100644
> --- a/tools/perf/util/include/linux/rbtree.h
> +++ b/tools/perf/util/include/linux/rbtree.h
> @@ -1 +1,2 @@
> +#include <stdbool.h>
>  #include "../../../../include/linux/rbtree.h"
>
> Alex?

Ah, makes sense to me. I wasn't previously aware of the
tools/perf/util/include/linux directory. I think your fix is fine.
(I don't understand how you hit the issue given the previous Makefile
fix, but I think your fix looks nicer)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
