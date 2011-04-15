Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab1DOXmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 19:42:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26498 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1DOXmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 19:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=aeFZcXD6DjH0w4OODfstoIngnb5BFFJM6xF52u491Ucsi8nu30X+CEE4lD4gc5ZPr/
         YOVEUE4rNLYscedlQTGQ==
Date: Fri, 15 Apr 2011 16:42:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
        Robin Holt <holt@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2] cpusets: randomize node rotor used in
 cpuset_mem_spread_node()
In-Reply-To: <20110415082051.GB8828@tiehlicka.suse.cz>
Message-ID: <alpine.DEB.2.00.1104151639080.3967@chino.kir.corp.google.com>
References: <20110414065146.GA19685@tiehlicka.suse.cz> <20110414160145.0830.A69D9226@jp.fujitsu.com> <20110415161831.12F8.A69D9226@jp.fujitsu.com> <20110415082051.GB8828@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011, Michal Hocko wrote:

> You are right. I was thinking about lazy approach and initialize those
> values when they are used for the first time. What about the patch
> below?
> 
> Change from v1:
> - initialize cpuset_{mem,slab}_spread_rotor lazily
> 

The difference between this v2 patch and what is already in the -mm tree 
(http://userweb.kernel.org/~akpm/mmotm/broken-out/cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch) 
is the lazy initialization by adding cpuset_{mem,slab}_spread_node()?

It'd probably be better to just make an incremental patch on top of 
mmotm-2011-04-14-15-08 with a new changelog and then propose with with 
your list of reviewed-by lines.

Andrew could easily drop the earlier version and merge this v2, but I'm 
asking for selfish reasons: please use NUMA_NO_NODE instead of -1.

Thanks!
