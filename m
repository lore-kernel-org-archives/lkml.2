Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab2HaJYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:24:50 -0400
Received: from mga02.intel.com ([134.134.136.20]:46349 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab2HaJYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:24:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,346,1344236400"; 
   d="scan'208";a="194017643"
From: Alexander Shishkin <alexander.shishkin@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, acme@redhat.com
Subject: Re: [PATCH v2 07/12] rbtree: adjust root color in rb_insert_color() only when necessary
In-Reply-To: <5040775C.3070205@intel.com>
References: <1342139517-3451-1-git-send-email-walken@google.com> <1342139517-3451-8-git-send-email-walken@google.com> <50406F60.5040707@intel.com> <CANN689EBA6yPk3pS-yXZ1-ticG7eU3mY1mWMWp2S3xhJ73ODFA@mail.gmail.com> <20120831011541.ddf8ed78.akpm@linux-foundation.org> <5040775C.3070205@intel.com>
User-Agent: Notmuch/0.12+187~ga2502b0 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Fri, 31 Aug 2012 12:25:10 +0300
Message-ID: <87txvjifbd.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Hunter <adrian.hunter@intel.com> writes:

> On 31/08/12 11:15, Andrew Morton wrote:
>> On Fri, 31 Aug 2012 01:07:24 -0700 Michel Lespinasse <walken@google.com> wrote:
>> 
>>> On Fri, Aug 31, 2012 at 1:01 AM, Adrian Hunter <adrian.hunter@intel.com> wrote:
>>>> This breaks tools/perf build in linux-next:
>>>>
>>>> ../../lib/rbtree.c: In function 'rb_insert_color':
>>>> ../../lib/rbtree.c:95:9: error: 'true' undeclared (first use in this function)
>>>> ../../lib/rbtree.c:95:9: note: each undeclared identifier is reported only once for each function it appears in
>>>> ../../lib/rbtree.c: In function '__rb_erase_color':
>>>> ../../lib/rbtree.c:216:9: error: 'true' undeclared (first use in this function)
>>>> ../../lib/rbtree.c: In function 'rb_erase':
>>>> ../../lib/rbtree.c:368:2: error: unknown type name 'bool'
>>>> make: *** [util/rbtree.o] Error 1
>>>
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

Whichever color like best. :) Consider my initial patch a bugreport.

Regards,
--
Alex
