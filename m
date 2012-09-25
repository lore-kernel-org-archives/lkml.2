Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2IYMBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:01:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43208 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab2IYMBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:01:42 -0400
Message-ID: <1348574486.3881.43.camel@twins>
Subject: Re: [PATCH 1/1] perf, Add support for Xeon-Phi PMU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>
Date: Tue, 25 Sep 2012 14:01:26 +0200
In-Reply-To: <20120925114225.GF14490@moon>
References: <alpine.DEB.2.02.1209201253060.27540@vincent-weaver-1.um.maine.edu>
	 <1348572758.3881.24.camel@twins> <20120925114225.GF14490@moon>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-09-25 at 15:42 +0400, Cyrill Gorcunov wrote:

> Guys, letme re-read this whole mail thread first since I have no clue
> what this remapping about ;)

x86_setup_perfctr() / set_ext_hw_attr() have special purposed 0 and -1
config values to mean -ENOENT and -EINVAL resp.

This means neither config value can be a 'real' event. Now it turns out
Xeon-Phi has an actual event 0, which is masked by these special case
thingies.
