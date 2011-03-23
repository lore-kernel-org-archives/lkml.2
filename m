Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab1CWFJo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 01:09:44 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:52384 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755064Ab1CWFJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 01:09:43 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/sCxlzg8DsO4JX1M1Cv8vApnT648dLUOkZSKlqTm
	rO2QN3ZwDn3lnY
Subject: Re: [patch 04/15] sched: throttle cfs_rq entities which exceed
 their local quota
From: Mike Galbraith <efault@gmx.de>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110323030449.047028257@google.com>
References: <20110323030326.789836913@google.com>
	 <20110323030449.047028257@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 06:09:36 +0100
Message-ID: <1300856976.7492.44.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 20:03 -0700, Paul Turner wrote:

> +static void check_cfs_rq_quota(struct cfs_rq *cfs_rq)
> +{
> +	if (within_bandwidth(cfs_rq))
> +		return;
> +
> +

Nit:  It'd be nice if classes agreed on naming convention to ease
rummaging.  In rt, it's bandwidth for bean counting parameters, but the
beans are runtime.  within_bandwidth() vs sched_rt_runtime_exceeded()
kinda pokes me in the eye when I look at the total.  Seems to me it
should be uniformly either quota or bandwidth, and uniformly runtime.

	-Mike


