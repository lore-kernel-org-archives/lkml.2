Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab0KJRZi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 12:25:38 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42923 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab0KJRZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 12:25:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C4H3hVG3+n79DzqxxGRNR1ywP74r+BwxQ+sGsrm84PMulK1mo0yBHfsweKvpjPJI8n
         qBDz3kENiNnVkGjHvtYtgQJ5k8Nokp/fNZgthHD+u7fJT7xQqXeKvAf/MxQCaq8n2hrx
         /4EVgLbaHokbMfDxqCWTLSCOoGJOb7ylFqYv4=
Date: Wed, 10 Nov 2010 18:25:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        ying.huang@intel.com, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC/Requirements/Design] h/w error reporting
Message-ID: <20101110172528.GB5360@nowhere>
References: <4cd9edd7543527b78@agluck-desktop.sc.intel.com> <20101110101450.GA18481@elte.hu> <1289400056.12418.139.camel@gandalf.stny.rr.com> <1289400234.2191.129.camel@laptop> <1289401781.12418.145.camel@gandalf.stny.rr.com> <1289403019.2084.17.camel@laptop> <1289407960.12418.169.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289407960.12418.169.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 11:52:40AM -0500, Steven Rostedt wrote:
> On Wed, 2010-11-10 at 16:30 +0100, Peter Zijlstra wrote:
> 
> > As for the buffer, I prefer a u64 aligned data stream, but the very
> > least I need is frame encapsulation. What I don't want _ever_ is stupid
> > sub-buffers. And no they're not needed, see the discussion about sync
> > markers a while back.
> 
> BTW, the sub buffers is just an implementation detail. I suspect that
> we'll have to end up with something that splits the buffer up. Whether
> we have 'markers' or something else. They all break down the buffer into
> a "sub-buffer".


If the size of the sub-buffers are tunable (all the same size inside a
whole buffer, but that size is tunable), then someone who doesn't want
to use subbuffers can just use a single big subbuffer :)

