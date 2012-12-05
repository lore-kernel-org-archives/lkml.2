Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab2LEXIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 18:08:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36211 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab2LEXIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 18:08:38 -0500
Date: Thu, 6 Dec 2012 00:08:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: John <da_audiophile@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Additional compiler optimization options
Message-ID: <20121205230835.GF6222@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	John <da_audiophile@yahoo.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1354745355.79857.YahooMailNeo@web140001.mail.bf1.yahoo.com>
 <20121205222738.GB6239@liondog.tnic>
 <1354748412.17691.YahooMailNeo@web140005.mail.bf1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1354748412.17691.YahooMailNeo@web140005.mail.bf1.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 03:00:12PM -0800, John wrote:
> > This only makes sense if you can show a noticeable performance
> 
> > improvement using one of the those -march options with at least one
> > benchmark from those which we have now in the kernel.
>
> Thank you for the feedback, Boris.  Can you point me to the built in
> benchmarks to which you referred?  I am interested in probing this
> further.

Maybe the easiest thing to do is build the kernel:

make -j<number_of_cores+1>

in your kernel directory and time it. You could get more precise output
if you trace that workload with perf:

$ perf stat --repeat 10 make -j<number_of_cores+1>

And look at how the perf output looks like.

For all those runs, you need hardware supporting any of these options
and the running kernel should each time be built with a different
optimization option.

This will show us whether differently optimized kernels show any
performance difference.

And then you can go and try other benchmarks like kernbench, hackbench,
etc, whatever your favourite search engine gives you for "linux
benchmarks"

HTH.

-- 
Regards/Gruss,
    Boris.
