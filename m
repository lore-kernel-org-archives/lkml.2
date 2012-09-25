Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2IYOx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:53:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50904 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2IYOx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:53:57 -0400
Date: Tue, 25 Sep 2012 18:53:52 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: Re: [PATCH 1/1] perf, Add support for Xeon-Phi PMU
Message-ID: <20120925145352.GK14490@moon>
References: <alpine.DEB.2.02.1209201253060.27540@vincent-weaver-1.um.maine.edu>
 <1348572758.3881.24.camel@twins>
 <20120925114225.GF14490@moon>
 <1348574486.3881.43.camel@twins>
 <20120925132754.GJ14490@moon>
 <alpine.DEB.2.02.1209251039350.6296@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209251039350.6296@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 10:45:02AM -0400, Vince Weaver wrote:
> 
> On Tue, 25 Sep 2012, Cyrill Gorcunov wrote:
> 
> > So guys, if understand all things correctly it's supposed to use some
> > -1/-2 as initial @config value for unsupported events, right? Vince,
> > may not it be easier to use bit 19 as a flag of valid event and clear
> > it when you write to msr, thus we will not have to change "zero is reserved"
> > semantics (otoh i'm not sure if it won't become a problem somewhere in
> > future with some new cpu :)
> 
> Well, we wouldn't want to use a reserved bit.
> In theory we could re-use bit 22 (enable) or bit 20 (APIC enable)
> because those values should in theory be set elsewhere and could probably
> be masked out at an appropriate place.
> 
> Is -2 really a valid cache event on Pentium 4?

Nope, there can't be config with -2 as valid value. So we can use -2
if needed as far as I can tell (the -1 can't be valid as well).

> Though I admit patching all of the various PMU drivers to use -1/-2 rather 
> than 0/-1 will be a pain, especially as many of them just default to 0
> with no initialization currently.

Yup, but if it'll be needed I can tune up p4 code (thought i'll need
some help in testing since i've no p4 cpu anymore).
