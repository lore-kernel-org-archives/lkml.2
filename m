Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab2DMMmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:42:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754941Ab2DMMmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:42:05 -0400
Date: Fri, 13 Apr 2012 14:41:29 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] perf, tool: Force guest machine definition option
Message-ID: <20120413124129.GC3384@m.brq.redhat.com>
References: <1334233262-5679-1-git-send-email-jolsa@redhat.com>
 <1334233262-5679-2-git-send-email-jolsa@redhat.com>
 <4F86E965.4010506@gmail.com>
 <20120413113207.GB3384@m.brq.redhat.com>
 <4F881A62.8060109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F881A62.8060109@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 06:21:54AM -0600, David Ahern wrote:
> On 4/13/12 5:32 AM, Jiri Olsa wrote:
> >>Even with guestmount specified you can hit this path -- e.g., no
> >>pid-based directory under guestmount for a VM.
> >
> >hm, something's wrong anyway..
> >
> >[root@dhcp-26-214 perf]# ./perf kvm --guest --guestkallsyms=./kallsyms record -p 1791
> >^C[ perf record: Woken up 1 times to write data ]
> >[ perf record: Captured and wrote 0.013 MB perf.data.guest (~576 samples) ]
> >[root@dhcp-26-214 perf]# ./perf kvm --guest --guestkallsyms=./kallsyms report --stdio
> >Segmentation fault (core dumped)
> >
> >it segfaults on guest mmap (attached bt) having NULL machine,
> >since no guest kernel buildid/dso was stored&loaded..
> >the host/guest machines code seems too 'complex' ;)
> 
> That was fixed on Monday I believe. Patch is in Arnaldo's urgent queue.

I get same error even on acme's urgent branch.. do you mean
below one?  It fixes the guest machine lookup for mmap event.

perf kvm: Finding struct machine fails for PERF_RECORD_MMAP
commit 7fb0a5ee8889488f7568ffddffeb66ddeb50917e
Author: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
Date:   Mon Apr 9 13:52:23 2012 +0530

In my case it looks like for some reason the guest buildid DSO
is not stored in record phase (no hits maybe?), so report won't
create guest machine record at all and get NULL machine.

jirka
