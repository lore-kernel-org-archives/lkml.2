Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0H0KS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 06:18:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:40507 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab0H0KSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 06:18:23 -0400
Subject: Re: [PATCH] pm_qos: Add system bus performance parameter
From: Peter Zijlstra <peterz@infradead.org>
To: skannan@codeaurora.org
Cc: markgross@thegnar.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <james.bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, khilman@deeprootsystems.com
In-Reply-To: <b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org>
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
	 <1282882403-29824-2-git-send-email-skannan@codeaurora.org>
	 <20100827064153.GB3414@gvim.org>
	 <b3ebe52382d37d37e93021c33cb4d6d9.squirrel@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 27 Aug 2010 12:17:14 +0200
Message-ID: <1282904234.1975.2094.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-27 at 01:10 -0700, skannan@codeaurora.org wrote:
> Ignoring other details for now, the biggest problem with throughput/KBps
> units is that PM QoS can't handle it well in its current state. For KBps
> the requests should be added together before it's "enforced". Just picking
> the maximum won't work optimally.
> 
> Another problem with using KBps is that the available throughput is going
> to vary depending on the CPU frequency since the CPU running at a higher
> freq is going to use more bandwidth/throughput than the same CPU running
> at a lower freq.
> 
> A KHz unit will side step both problems. It's not the most ideal in theory
> but it's simple and gets the job done since, in our case, there aren't
> very many fine grained levels of system bus frequencies (and corresponding
> throughputs).
> 
> I understand that other architectures might have different practical
> constraints and abilities and I didn't want to impose the KHz limitation
> on them. That's the reason I proposed a parameter whose units is defined
> by the "enforcer".

Like Mark said, unit-less constraints are impossible to use correctly.
What if a driver moves from one platform to another?

Also, the KHz thing you propose simply doesn't make sense, given a fixed
bus width, KBs and KHz have a fixed ratio, and thus you get the exact
same problem you initially had and refused to fix.


