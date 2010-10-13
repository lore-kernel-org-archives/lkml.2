Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab0JMPNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:13:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab0JMPNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:13:45 -0400
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: Dwarf cfi based user callchains
References: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Wed, 13 Oct 2010 11:13:27 -0400
In-Reply-To: <1286946421-32202-1-git-send-regression-fweisbec@gmail.com> (Frederic Weisbecker's message of "Wed, 13 Oct 2010 07:06:52 +0200")
Message-ID: <y0mmxqi6s88.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Frederic Weisbecker <fweisbec@gmail.com> writes:

> [...]
> This brings dwarf cfi based callchain for userspace apps that don't have
> frame pointers.

Interesting approach!

> [...]
> - it's slow. A first improvement to make it faster is to support binary
>   search from .eh_frame_hdr. 

In systemtap land, we did find a dramatic improvement from this too.

Have you measured the cost of transcribing of potentially large chunks
of the user stacks?  We did not seriously evaluate this path, since we
encounter megabyte+ stacks in larger userspace apps, and copying THAT
out seemed absurd.


- FChE
