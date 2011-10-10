Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab1JJOpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 10:45:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34118 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1JJOpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 10:45:40 -0400
Date: Mon, 10 Oct 2011 16:45:38 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        acme@redhat.com, ming.m.lin@intel.com, robert.richter@amd.com,
        ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for Intel X86
Message-ID: <20111010144538.GZ14482@one.firstfloor.org>
References: <1317912555-9559-8-git-send-email-eranian@google.com> <20111006153229.GJ14482@one.firstfloor.org> <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com> <CABPqkBReqBhFFKsLPfbzFHL7hs2hXSJ8tTZuP9D-2N2MGiB9Mw@mail.gmail.com> <1317984122.31132.6.camel@twins> <CABPqkBTxxS-vuAycDJO-aJNE4EpCLF8xyPtJ1Jzv26f15HJC8A@mail.gmail.com> <1317986519.31132.13.camel@twins> <4E8EE885.9040703@hitachi.com> <20111010060927.GG32173@elte.hu> <4E92FBAD.3000108@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E92FBAD.3000108@hitachi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ah, nice. Maybe we need another test binary, since current one is
> just ensuring the output of objdump and decoder is same.
> anyway it's not so difficult if it feeds random binaries to
> ensure the decoder doesn't access bad address.

Pure /dev/urandom is not good because it cannot be ever reproduced.
Better use a PRNG with random seed from urandom, but print the seed.

In addition to random I would do fuzzing: take an existing stream
and just corrupt some bits and groups of bits. This will exercise different 
paths.  In fact fuzzing is probably better than random for most tests.

Not sure it's needed to run on every build though, just checks
now and then should be sufficient.

-Andi
