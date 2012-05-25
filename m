Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab2EYKBq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 06:01:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35833 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2EYKBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 06:01:44 -0400
Subject: Re: [PATCH 02/16] perf: Add ability to attach registers dump to
 sample
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        gorcunov@openvz.org, tzanussi@gmail.com, mhiramat@redhat.com,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
In-Reply-To: <20120524115206.GB1775@m.brq.redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
	 <1337801535-12865-3-git-send-email-jolsa@redhat.com>
	 <1337853048.9783.92.camel@laptop>
	 <CABPqkBR9hewjNUJf9ByD-jHc42e_qwQiKoP68RyL7BU8Q7BGgQ@mail.gmail.com>
	 <1337856142.9783.104.camel@laptop> <20120524115206.GB1775@m.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 12:01:23 +0200
Message-ID: <1337940083.9783.177.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 13:52 +0200, Jiri Olsa wrote:
> 
> My intention was to make this general. I could just add
> bitmask for each type (user regs mask for now) but I wanted
> to be consistent with other SAMPLE_* stuff..
> 
> So current patch adds PERF_SAMPLE_REGS sample_type bit.
> Once it is set, the 'sample_regs' value is checked for what
> type of registers you want for sample.
> 
> Each type then has separate bitmask in case you want different
> registers for each type. Allowing whatever combination of regs dump
> being added to the sample, since it seems there's no firm
> decision on what combination might be needed.
> 
> Sure we can make the same with bitmasks for each regs type,
> and check the presence in sample by bitmask being not empty. 

Right, I don't know. But none of this was in the changelog.

Also, I just checked, there's architectures with more than 64 GP
registers ;-) (IA64 has 128 64bit integer registers for instance).

Now IA64 is the only one I could find, and we don't actually support
perf for it, and seeing how 'popular' IA64 is we might never, but still.





