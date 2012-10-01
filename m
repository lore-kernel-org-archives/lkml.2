Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2JAIte (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 04:49:34 -0400
Received: from mx2.parallels.com ([64.131.90.16]:60619 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476Ab2JAItd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 04:49:33 -0400
Message-ID: <5069584A.8090809@parallels.com>
Date: Mon, 1 Oct 2012 12:46:02 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <devel@openvz.org>,
        <linux-mm@kvack.org>, Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
References: <50638793.7060806@parallels.com> <20120926230807.GC10453@mtj.dyndns.org> <20120927142822.GG3429@suse.de> <20120927144942.GB4251@mtj.dyndns.org> <50646977.40300@parallels.com> <20120927174605.GA2713@localhost> <50649EAD.2050306@parallels.com> <20120930075700.GE10383@mtj.dyndns.org> <20120930080249.GF10383@mtj.dyndns.org> <1348995388.2458.8.camel@dabdike.int.hansenpartnership.com> <20120930103732.GK10383@mtj.dyndns.org>
In-Reply-To: <20120930103732.GK10383@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2012 02:37 PM, Tejun Heo wrote:
> Hello, James.
> 
> On Sun, Sep 30, 2012 at 09:56:28AM +0100, James Bottomley wrote:
>> The beancounter approach originally used by OpenVZ does exactly this.
>> There are two specific problems, though, firstly you can't count
>> references in generic code, so now you have to extend the cgroup
>> tentacles into every object, an invasiveness which people didn't really
>> like.
> 
> Yeah, it will need some hooks.  For dentry and inode, I think it would
> be pretty well isolated tho.  Wasn't it?
> 

We would still need something for the stack. For open files, and for
everything that becomes a potential problem. We then end up with 35
different knobs instead of one. One of the perceived advantages of this
approach, is that it condenses as much data as a single knob as
possible, reducing complexity and over flexibility.

