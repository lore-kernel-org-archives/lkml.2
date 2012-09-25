Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab2IYLwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:52:09 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63487 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2IYLwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:52:07 -0400
Date: Tue, 25 Sep 2012 15:51:56 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Subject: Re: [PATCH 1/1] perf, Add support for Xeon-Phi PMU
Message-ID: <20120925115156.GB18666@moon>
References: <alpine.DEB.2.02.1209201253060.27540@vincent-weaver-1.um.maine.edu>
 <1348572758.3881.24.camel@twins>
 <20120925114225.GF14490@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925114225.GF14490@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 03:42:25PM +0400, Cyrill Gorcunov wrote:
> On Tue, Sep 25, 2012 at 01:32:38PM +0200, Peter Zijlstra wrote:
> > On Thu, 2012-09-20 at 13:03 -0400, Vince Weaver wrote:
> > > One additional complication:  some of the cache events map to 
> > > event "0".  This causes problems because the generic events code
> > > assumes "0" means not-available.  I'm not sure the best way to address
> > > that problem. 
> > 
> > For all except P4 we could remap the 0 value to -2, that has all high
> > bits set (like the -1) which aren't used by hardware.
> > 
> > P4 is stuffing two registers in the 64bit config space and actually has
> > them all in use I think.. Cyrill?
> 
> Yeah, we use almost all 64 bits in config. I tried to describe the bitmaps
> in perf_event_p4.h (see Notes on internal configuration of ESCR+CCCR tuples).
> 
> Guys, letme re-read this whole mail thread first since I have no clue
> what this remapping about ;)

If we need some special mark in config I can try to free hight bit in
@config and move it somehwere in low 32 bits (there are bits 28-29 which
i can use for that). Ie I can provide the sign bit, would it be enough?
