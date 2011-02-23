Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab1BWMYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:24:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:52307 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1BWMYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:24:32 -0500
Subject: Re: [CFS Bandwidth Control v4 4/7] sched: unthrottle cfs_rq(s) who
 ran out of quota at period refresh
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110216031841.161743484@google.com>
References: <20110216031831.571628191@google.com>
	 <20110216031841.161743484@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 23 Feb 2011 13:23:38 +0100
Message-ID: <1298463818.2217.497.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-15 at 19:18 -0800, Paul Turner wrote:

> +static inline const struct cpumask *sched_bw_period_mask(void)
> +{
> +       return cpu_rq(smp_processor_id())->rd->span;
> +}

Some day I'm going to bite the bullet and merge part of cpusets into
this controller and have Balbir take the node part into the memcg thing
and then make (cpu||memcg) ^ cpuset

Feh.
