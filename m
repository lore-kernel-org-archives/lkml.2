Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408Ab2INOyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:54:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:38477 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2INOyD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:54:03 -0400
Message-ID: <1347634409.7172.58.camel@twins>
Subject: Re: [RFC] cgroup TODOs
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>,
        Glauber Costa <glommer@parallels.com>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Date: Fri, 14 Sep 2012 16:53:29 +0200
In-Reply-To: <20120914142539.GC6221@redhat.com>
References: <20120913205827.GO7677@google.com>
	 <20120914142539.GC6221@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-14 at 10:25 -0400, Vivek Goyal wrote:
> So while % model is more intutive to users, it is hard to implement.

I don't agree with that. The fixed quota thing is counter-intuitive and
hard to use. It begets you questions like: why, if everything is idle
except my task, am I not getting the full throughput.

It also makes adding entities harder because you're constrained to 100%.
This means you have to start each new cgroup with 0% because any !0
value will eventually get you over 100%, it also means you have to do
some form of admission control to make sure you never get over that
100%.

Starting with 0% is not convenient for people.. they think this is the
wrong default, even though as argued above, it is the only possible
value.

>  So
> an easier way is to stick to the model of relative weights/share and
> let user specify relative importance of a virtual machine and actual
> quota or % will vary dynamically depending on other tasks/components
> in the system.
> 
> Thoughts? 

cpu does the relative weight, so 'users' will have to deal with it
anyway regardless of blk, its effectively free of learning curve for all
subsequent controllers.

Now cpu also has an optional upper limit. But its optional for those
people who do want it (also its expensive).

For RT we must use fixed quota since variable service completely defeats
determinism, RT is 'special' and hard to use anyway, so making it harder
is fine.
