Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab2LSVzt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 16:55:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:47427 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab2LSVzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 16:55:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,320,1355126400"; 
   d="scan'208";a="264646988"
From: Andi Kleen <andi@firstfloor.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf tool: Add non arch events for SandyBridge microarchitecture
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
	<1355751425-7993-4-git-send-email-jolsa@redhat.com>
Date: Wed, 19 Dec 2012 13:55:43 -0800
In-Reply-To: <1355751425-7993-4-git-send-email-jolsa@redhat.com> (Jiri Olsa's
	message of "Mon, 17 Dec 2012 14:37:05 +0100")
Message-ID: <m2zk19d7vk.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa <jolsa@redhat.com> writes:

> Adding non architectural event aliases for Sandy Bridge
> microarchitecture.

"SandyBridge" is not necessarily unique. There are flavours
of sandy bridge with slightly different events (e.g. in offcore)
Also there's uncores too, which are very different between
different SandyBridges.

I would merge all these little files into a single file.
I don't think anyone wants hundreds of new files for this, 
if you do it for multiple CPUs.

Besides it would waste insane amounts of space on most file systems
without tail packing -- each of your little files takes 4K plus an inode
and directory entry.

Intel normally uses a spreadsheet CSV format.

Best would be probably to just teach perf about reading one of those
standard formats, then they could be just downloaded somewhere.
I have some python scripts that do it as a wrapper.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
