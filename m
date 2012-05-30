Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab2E3LlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 07:41:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58178 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2E3LlF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 07:41:05 -0400
Message-ID: <1338378051.26856.267.camel@twins>
Subject: Re: [PATCH v3 4/6] add a new scheduler hook for context switch
From: Peter Zijlstra <peterz@infradead.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org,
        Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com,
        Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>
Date: Wed, 30 May 2012 13:40:51 +0200
In-Reply-To: <1338376851.26856.260.camel@twins>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
	 <1338371317-5980-5-git-send-email-glommer@parallels.com>
	 <1338376851.26856.260.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 13:20 +0200, Peter Zijlstra wrote:
> 
> $ perf stat -e cycles --repeat 100 perf bench sched messaging -p -g 100
> 
>     48,826,146,710 cycles  #    2.470 GHz  ( +-  0.17% )
>        2.149005270 seconds time elapsed    ( +-  0.12% ) 

A repeat count of 250 dropped it down to:

        2.144582157 seconds time elapsed    ( +-  0.08% )

Also, if you're poking at the context switch path, something like:

$ taskset 1 perf stat -e cycles --repeat 10 perf bench sched pipe -l 100000

gives a good number and is usually more stable than hackbench.
