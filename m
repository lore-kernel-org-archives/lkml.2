Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2IYLc6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:32:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57183 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab2IYLc4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:32:56 -0400
Message-ID: <1348572758.3881.24.camel@twins>
Subject: Re: [PATCH 1/1] perf, Add support for Xeon-Phi PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Date: Tue, 25 Sep 2012 13:32:38 +0200
In-Reply-To: <alpine.DEB.2.02.1209201253060.27540@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1209201253060.27540@vincent-weaver-1.um.maine.edu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-09-20 at 13:03 -0400, Vince Weaver wrote:
> One additional complication:  some of the cache events map to 
> event "0".  This causes problems because the generic events code
> assumes "0" means not-available.  I'm not sure the best way to address
> that problem. 

For all except P4 we could remap the 0 value to -2, that has all high
bits set (like the -1) which aren't used by hardware.

P4 is stuffing two registers in the 64bit config space and actually has
them all in use I think.. Cyrill?
