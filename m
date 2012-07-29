Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab2G2Wx2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 18:53:28 -0400
Received: from ozlabs.org ([203.10.76.45]:48643 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab2G2Wx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 18:53:27 -0400
Date: Mon, 30 Jul 2012 08:45:52 +1000
From: Paul Mackerras <paulus@samba.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        a.p.zijlstra@chello.nl, mingo@kernel.org, cjashfor@linux.vnet.ibm.com,
        fweisbec@gmail.com, eranian@google.com, gorcunov@openvz.org,
        tzanussi@gmail.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org
Subject: Re: [PATCH 01/17] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120729224552.GA21364@bloggs.ozlabs.ibm.com>
References: <1342959280-5361-1-git-send-email-jolsa@redhat.com>
 <1342959280-5361-2-git-send-email-jolsa@redhat.com>
 <20120726175104.GA27546@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726175104.GA27546@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 02:51:04PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sun, Jul 22, 2012 at 02:14:24PM +0200, Jiri Olsa escreveu:
> > This brings a new API to help the selective dump of registers on
> > event sampling, and its implementation for x86 arch.
> > 
> > Added HAVE_PERF_REGS config option to determine if the architecture
> > provides perf registers ABI.
> > 
> > The information about desired registers will be passed in u64 mask.
> > It's up to the architecture to map the registers into the mask bits.
> > 
> > For the x86 arch implementation, both 32 and 64 bit registers
> > bits are defined within single enum to ensure 64 bit system can
> > provide register dump for compat task if needed in the future.
> 
> 
> Anton, Paul, Ben,
> 
> 	Does this look OK for PPC?

Yes, it looks fine.  I assume we only want integer regs here, not
floating-point or vector regs.

Paul.
