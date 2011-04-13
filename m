Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab1DMAW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 20:22:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24458 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab1DMAW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 20:22:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Ji/CJdxeDmBCcP4RVt1NiRuYFBFpDKq6IpcbdzqIFmoCQAoBa32qfE1ZgYbesnu4f7
         di4XOEn7oF7P5qjHKsyw==
Date: Tue, 12 Apr 2011 17:22:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Chris McDermott <lcm@linux.vnet.ibm.com>
Subject: Re: [PATCH resend^2] mm: increase RECLAIM_DISTANCE to 30
In-Reply-To: <1302557371.7286.16607.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1104121719430.10966@chino.kir.corp.google.com>
References: <20110411172004.0361.A69D9226@jp.fujitsu.com> <1302557371.7286.16607.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Apr 2011, Dave Hansen wrote:

> > This patch raise zone_reclaim_mode threshold to 30. 30 don't have
> > specific meaning. but 20 mean one-hop QPI/Hypertransport and such
> > relatively cheap 2-4 socket machine are often used for tradiotional
> > server as above. The intention is, their machine don't use
> > zone_reclaim_mode.
> 
> I know specifically of pieces of x86 hardware that set the information
> in the BIOS to '21' *specifically* so they'll get the zone_reclaim_mode
> behavior which that implies.
> 

That doesn't seem like an argument against this patch, it's an improper 
configuration unless the remote memory access has a latency of 2.1x that 
of a local access between those two nodes.  If that's the case, then it's 
accurately following the ACPI spec and the VM has made its policy decision 
to enable zone_reclaim_mode as a result.  I'm surprised that they'd play 
with their BIOS to enable this by default, those, when it's an easily 
tunable sysctl.
