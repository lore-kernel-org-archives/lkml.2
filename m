Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab1ASWci (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:32:38 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:56882 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab1ASWcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:32:36 -0500
Date: Wed, 19 Jan 2011 23:32:34 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Miller <davem@davemloft.net>,
        richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
	Unknown relocation: 36
Message-ID: <20110119223234.GA20218@merkur.ravnborg.org>
References: <20110118.223247.241909079.davem@davemloft.net> <20110118.232045.58440904.davem@davemloft.net> <20110119153326.GC11022@Krystal> <20110119.134047.232915743.davem@davemloft.net> <1295474423.12215.1612.camel@gandalf.stny.rr.com> <20110119222144.GC23544@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119222144.GC23544@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I still wonder how a 32-bit system can generate an unaligned access trap for an
> access to a 64-bit variable aligned on 32-bit, given that there is, by
> definition, no 64-bit memory accesses available on the architecture ?

>From the SPARC V8 manual (this is the 32 bit version of SPARC):

    Load/Store Instructions

    ...
    Integer load and store instructions support byte (8-bit), halfword (16-bit), word
    (32-bit), and doubleword (64-bit) accesses.
    ...

    Alignment Restrictions

    Halfword accesses must be aligned on a 2-byte boundary, word accesses (which
    include instruction fetches) must be aligned on a 4-byte boundary, and doubleword
    accesses must be aligned on an 8-byte boundary. An improperly aligned
    address causes a load or store instruction to generate a mem_address_not_aligned
    trap.


	Sam
