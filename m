Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760621Ab2EIRat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:30:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:41369 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374Ab2EIRas convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:30:48 -0400
Message-ID: <1336584641.2527.65.camel@twins>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, pjt@google.com, tglx@linutronix.de,
        seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 09 May 2012 19:30:41 +0200
In-Reply-To: <20120509172611.GC8135@gmail.com>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
	 <1336570043.2527.38.camel@twins>
	 <CA+55aFyjGZ=PLOBfyFub4kS3r2vJ0SFD58rTf21koPodFTSARQ@mail.gmail.com>
	 <1336584160.2527.62.camel@twins> <20120509172611.GC8135@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 19:26 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > A "%.*pb" is the only interface that can work for a "sized" 
> > > bitmap (with obviously fixed-length ones being possible with 
> > > a "%.32bp" like thing)
> > 
> > Right, sadly that also generates a warning :/
> 
> Why not use what I suggested, %*pb? It also doubles as a width 
> field in essence, as bitmap output is fundamentally fixed width.

The bitmap list output uses RLE and generates things like:

 6-11,18-23

Its the stuff used for all the sched_domain output etc..



