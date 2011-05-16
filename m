Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab1EPP6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 11:58:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:58191 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423Ab1EPP6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 11:58:37 -0400
Subject: Re: [patch 08/15] sched: throttle cfs_rq entities which exceed
 their local runtime
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110503092905.163081832@google.com>
References: <20110503092846.022272244@google.com>
	 <20110503092905.163081832@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 May 2011 17:58:15 +0200
Message-ID: <1305561495.2466.4449.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 02:28 -0700, Paul Turner wrote:
> +       /*
> +        * it's possible active load balance has forced a throttled cfs_rq to
> +        * run again, we don't want to re-throttled in this case.
> +        */
> +       if (cfs_rq_throttled(cfs_rq))
> +               return; 

expand a little on this, why would load-balancing interact with a
throttled group? load-balancing should fully ignore these things,
they're not runnable after all.
