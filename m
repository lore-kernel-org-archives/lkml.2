Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab1D2OI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:08:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61705 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1D2OI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:08:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=V91Md50seZ8z7reEwFp1ETFDo6Bdll6gbaadZM88PHj6woOYCsWY+kdT7k7L5gyUdL
         sAkjncrM01EWf4OacieIpGpNaYXIKdyUFBrwLM6+yvsIGMSTR2JgjCjCBq3/zSYJPOCv
         xk0jKpsJDW/g29f3zgOKNK/TX2YFXaAjZhjgY=
Date: Fri, 29 Apr 2011 16:08:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 00/18] RAS daemon: Easter Eggs Edition
Message-ID: <20110429140844.GB1768@nowhere>
References: <1303576100-425-1-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303576100-425-1-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 06:28:02PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Ok, here's yet another version of the RAS daemon patchset. This one
> changes all the event handling to how it is done in test__basic_mmap(),
> as acme suggested. Patchset is against tip/perf/core from today.
> 
> With this I can inject an mce using the python script below (yeah, work
> in progress in itself):
> 
> $ mcegen.py -i sw
> 
> 	[ this will inject a random MCE using the mce_amd_inj.ko module ]
> 
> and in /var/log/ras.log I get:
> 
> MCE on cpu 0, status: 0xf200210000000853, addr: 0x0000000000000000
> MCE on cpu 0, status: 0x9800400000000015, addr: 0x0000000000000000
> MCE on cpu 0, status: 0xfc00200000050e0f, addr: 0x0000000000000000
> MCE on cpu 0, status: 0x98004100001c010b, addr: 0x0000000000000000
> MCE on cpu 0, status: 0xbc00200000000843, addr: 0x0000000000000000
> MCE on cpu 0, status: 0xda00410000080e0f, addr: 0x0000000000000000
> 
> Yep, it is still raw info but you can do almost anything with that info
> in userspace.
> 
> Next on the TODO list is changing the tracepoint to convey the decoded
> info too which should be a fairly simple task to do.
> 
> So we've got the basic design hammered out methinks, the persistent
> event is off by default for now and since rebasing this pile is always a
> great PITA for me due to other developments in tools/perf, I'd like it
> very much if I could offload it in -tip soon.

If you want to accelerate that, I suggest you cut your patchset into smaller
sets and focus on merging them piece by piece. Few people are going to review
18 patches at once. They may plan to scatter their review over days but
that doesn't scale well, and it naturally reduces the number of reviewers.

You could start with exporting trace things into tools/trace, post the
few concerned patches and iterate them until everyone is happy. Then
switch to another subset of the big thing.

Hm?
