Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2JMNnt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 09:43:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:48475 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab2JMNnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 09:43:47 -0400
In-Reply-To: <20121013062453.GH4640@truffula.fritz.box>
References: <1349827466.26044.16@snotra> <50759105.2000406@wwwdotorg.org> <1349885393.21493.2@snotra> <5075A0AA.2000605@wwwdotorg.org> <20121010231835.GH28467@truffula.fritz.box> <5078525B.9030008@wwwdotorg.org> <20121013062453.GH4640@truffula.fritz.box>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <3C5DD611-6F36-4D13-9A88-377A8E30AAA5@kernel.crashing.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Scott Wood <scottwood@freescale.com>, Michal Marek <mmarek@suse.cz>,
        devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: dtc: import latest upstream dtc
Date: Sat, 13 Oct 2012 15:42:35 +0200
To: David Gibson <david@gibson.dropbear.id.au>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Oh, that's strange.  I'm pretty sure I've used -x assembler when I've
> experimented with using cpp on dts manually before, and it seems to
> have worked.

Maybe you used "-x assembler-with-cpp"?  That should work better ;-)
Or just use the "-traditional-cpp" option, i.e. "gcc -E -traditional- 
cpp".

>   Note that IIRC with gcc cpp, -x assembler also means
> that # won't be handled as a cpp directive except in column 0 which is
> also an advantage for us, although no longer essential with your
> escaping support.  Not all cpps have an equivalent option, though.

This is how the traditional C pre-processor behaves.  I don't think
this is exactly what matters for DTS, or does it ever happen that
you have a # preceded only by whitespace?  The # and ## stringification
and token pasting ops will of course bite you with the ISO C pre- 
processor,
indeed.


Segher

