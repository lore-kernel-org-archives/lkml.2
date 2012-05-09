Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760544Ab2EIRXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:23:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37585 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab2EIRXt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:23:49 -0400
Message-ID: <1336584160.2527.62.camel@twins>
Subject: Re: [RFC][PATCH] printk: Add %pb to print bitmaps
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Igor Mammedov <imammedo@redhat.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 09 May 2012 19:22:40 +0200
In-Reply-To: <CA+55aFyjGZ=PLOBfyFub4kS3r2vJ0SFD58rTf21koPodFTSARQ@mail.gmail.com>
References: <1336559908-32533-1-git-send-email-imammedo@redhat.com>
	 <4FAA452A.1070909@gmail.com> <4FAA588B.5010404@redhat.com>
	 <1336564330.2527.23.camel@twins> <4FAA5BFB.40309@redhat.com>
	 <1336566096.2527.30.camel@twins> <1336566644.2527.33.camel@twins>
	 <1336570043.2527.38.camel@twins>
	 <CA+55aFyjGZ=PLOBfyFub4kS3r2vJ0SFD58rTf21koPodFTSARQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 10:15 -0700, Linus Torvalds wrote:
> 
> The "bc" and "bn" would work, except for the fact that I doubt they
> are printed out enough to matter.

There's a number %pbc candidates in the scheduler that would be nice to
not have to do manually.

> A "%.*pb" is the only interface that can work for a "sized" bitmap
> (with obviously fixed-length ones being possible with a "%.32bp" like
> thing)

Right, sadly that also generates a warning :/

> But the whole va_args games you play are not acceptable. %p *will*
> continue to take a void *, and nothing else. 

The va_args() games are dead.
