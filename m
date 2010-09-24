Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab0IXNdA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:33:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:46164 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0IXNc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:32:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=YHsIQo8mLqDPWbaw5RIAtzBWQn6msGIkWvkNpcyN0rX2mQF0VHOHY08eQvhn2Fnf9E
         t+hKm4n1AfjVrMHne53K2asBjmomblnKhuVcYMctBZ0CIUldToGIj3mkvx/BMjnRBi/r
         2OcPBHEpfgR8SxWkimAq1T+a1qcKqXXeUUxZ0=
Subject: Re: [PATCH 7/8] net: Allow setting the network namespace by fd
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: David Lamparter <equinox@diac24.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100924125704.GA1551619@jupiter.n2.diac24.net>
References: <m1ocborgq7.fsf@fess.ebiederm.org>
	 <m1hbhgq1v1.fsf@fess.ebiederm.org> <1285240926.5036.7.camel@bigi>
	 <20100923145856.GB1160234@jupiter.n2.diac24.net>
	 <1285329084.13976.661.camel@bigi>
	 <20100924125704.GA1551619@jupiter.n2.diac24.net>
Content-Type: text/plain
Date: Fri, 24 Sep 2010 09:32:53 -0400
Message-Id: <1285335173.13976.693.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 14:57 +0200, David Lamparter wrote:

> No. While you sure could associate routes with devices, they don't
> *functionally* reside on top of network devices. They reside on top of
> the entire IP configuration, 

I think i am not clearly making my point. There are data dependencies;
If you were to move routes, youd need everything that routes depend on.
IOW, if i was to draw a functional graph, routes would appear on top
of netdevs (I dont care what other functional blocks you put in between
or sideways to them).

> and in case of BGP they even reside on top
> of your set of peerings and their data.
> Even if you could "move" routes together with a network device, the
> result would be utter nonsense. 

You could argue that moving a netdevice where some of its fundamental
properties such as an ifindex change is utter nonsense. But you can
work around it.

> The routes depend on your BGP view, and
> if your set of interfaces (and peers) changes, your routes will change.
> Your bgpd will, either way, need to set up new peerings and redo best
> path evaluations.

Worst case scenario, yes. I am beginning to get a feeling we are trying 
to achieve different goals maybe? Why are you even migrating netdevs?

> (On an unrelated note, how often are you planning to move stuff between
> namespaces? I don't expect to be moving stuff except on configuration
> events...)

Triggering on config events is useful and it is likely the only
possibility if you assumed the other namespace is remote. But if could
send a single command to migrate several things in the kernel (in my
case to recover state to a different ns), then that is much simpler and
uses the least resources (memory, cpu, bandwidth). I admit it is very
hard to do in most cases where the underlying dependencies are evolving
and synchronizing via user space is the best approach. The example
of route table i pointed to is simple.
Besides that: dynamic state created in the kernel that doesnt have to be
recreated by the next arriving 100K packets helps to improve recovery.

cheers,
jamal

