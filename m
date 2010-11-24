Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0KXTKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:10:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39304 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359Ab0KXTKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:10:30 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=UaNWXry1k3EA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=8pwfNWcFVFjxoWGzbK4A:9 a=SgAgXFcEd8H03jmH-sGTloq_wEsA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/3] jump label: add enabled/disabled state to jump
 label key entries
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        mathieu.desnoyers@polymtl.ca, hpa@zytor.com, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, sam@ravnborg.org, ddaney@caviumnetworks.com,
        michael@ellerman.id.au, linux-kernel@vger.kernel.org
In-Reply-To: <20101124152118.GC2815@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com>
	 <d03959060763fecdf2523a3f1353e1fc59f8f4a1.1290546539.git.jbaron@redhat.com>
	 <1290586809.2072.424.camel@laptop> <20101124145401.GA2815@redhat.com>
	 <1290611702.30543.488.camel@gandalf.stny.rr.com>
	 <20101124152118.GC2815@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 24 Nov 2010 10:57:26 -0500
Message-ID: <1290614246.30543.536.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 10:21 -0500, Jason Baron wrote:

> The keys are simply the address of a variable or structure (so as to be
> unique). We can put pointers or anything else in the variable.

Note, there is not a 1 to 1 with keys and places that need to be
patched.

Doing the following objdump:

  objdump -dr vmlinux | grep 'jmpq.*<trace_kmalloc' | wc -l
375

That's 375 instances of kmalloc tracepoints[*] and one key. How do you
handle this?

-- Steve




[*] this should be fixed, we probably should find a way to move the
tracepoint into the kmalloc functions that are not inlined.

