Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2JBJb2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 05:31:28 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:41686 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752916Ab2JBJb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 05:31:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+xB/J+Owix98QMx/PNGKQIP6isaGkkKqSOGD6s4P
	GnF1X2IyKgE2Ch
Message-ID: <1349170282.7086.56.camel@marge.simpson.net>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 02 Oct 2012 11:31:22 +0200
In-Reply-To: <20121002084501.GL29125@suse.de>
References: <20121002065143.GK29125@suse.de>
	 <1349164176.7086.43.camel@marge.simpson.net>
	 <20121002084501.GL29125@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 09:45 +0100, Mel Gorman wrote: 
> On Tue, Oct 02, 2012 at 09:49:36AM +0200, Mike Galbraith wrote:

> > Hm, 518cd623 fixed up the troubles I saw.  How exactly are you running
> > this?
> > 
> 
> You saw problems with TCP_RR where as this is UDP_STREAM.

Yeah, but I wanted to stare at UDP_STREAM as you run it to see if it
would tell me anything about why those numbers happen.

> I'm running this through MMTests with a version of the
> configs/config-global-dhp__network-performance file that only runs
> netperf-udp. Ultimately it runs netperf for a size something like
> this
> 
> SIZE=64
> taskset -c 0 netserver
> taskset -c 1 netperf -t UDP_STREAM -i 50,6 -I 99,1 -l 20 -H 127.0.0.1 -- -P 15895 -s 32768 -S 32768 -m $SIZE -M $SIZE

Thanks.

-Mike


