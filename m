Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab2LTLNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:13:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab2LTLNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:13:48 -0500
Date: Thu, 20 Dec 2012 12:13:13 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 3/3] perf tool: Add non arch events for SandyBridge
 microarchitecture
Message-ID: <20121220111313.GB1241@krava.brq.redhat.com>
References: <1355751425-7993-1-git-send-email-jolsa@redhat.com>
 <1355751425-7993-4-git-send-email-jolsa@redhat.com>
 <m2zk19d7vk.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2zk19d7vk.fsf@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 01:55:43PM -0800, Andi Kleen wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> > Adding non architectural event aliases for Sandy Bridge
> > microarchitecture.
> 
> "SandyBridge" is not necessarily unique. There are flavours
> of sandy bridge with slightly different events (e.g. in offcore)
> Also there's uncores too, which are very different between
> different SandyBridges.
> 
> I would merge all these little files into a single file.
> I don't think anyone wants hundreds of new files for this, 
> if you do it for multiple CPUs.

right, that's better

> 
> Besides it would waste insane amounts of space on most file systems
> without tail packing -- each of your little files takes 4K plus an inode
> and directory entry.
> 
> Intel normally uses a spreadsheet CSV format.

Is there anything in public I could download and check?

> 
> Best would be probably to just teach perf about reading one of those
> standard formats, then they could be just downloaded somewhere.

so, when you say standard format.. CSV? like:

BR_MISP_EXEC.ALL_BRANCHES,event=0x89,umask=0xff
BR_MISP_EXEC.COND,event=0x89,umask=0x1
BR_MISP_EXEC.DIRECT_NEAR_CALL,event=0x89,umask=0x10
BR_MISP_EXEC.INDIRECT_JMP_NON_CALL_RET,event=0x89,umask=0x4
BR_MISP_EXEC.INDIRECT_NEAR_CALL,event=0x89,umask=0x20
BR_MISP_EXEC.NONTAKEN,event=0x89,umask=0x40
BR_MISP_EXEC.RETURN_NEAR,event=0x89,umask=0x8
BR_MISP_EXEC.TAKEN,event=0x89,umask=0x80

would be no big change for alias loader

thanks,
jirka
