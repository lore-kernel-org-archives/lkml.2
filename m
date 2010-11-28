Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110Ab0K1BwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 20:52:13 -0500
Received: from smtp-out.google.com ([74.125.121.35]:6825 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab0K1BwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 20:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PtrFkpyEyD7XC2xVvUnQgK9QRsV7GcCb/d+S0u/gsRmUxhrPaewmo5OFxLosGMK7bM
         3PCanhTqDDGMDpm/Me9A==
Date: Sat, 27 Nov 2010 17:52:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg KH <gregkh@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: Re: [patch 2/2 v2] mm: add node hotplug emulation
In-Reply-To: <20101122005658.GA6710@suse.de>
Message-ID: <alpine.DEB.2.00.1011271750140.3764@chino.kir.corp.google.com>
References: <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com> <20101119003225.GB3327@shaohui> <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201827540.12889@chino.kir.corp.google.com> <20101121173438.GA3922@suse.de> <alpine.DEB.2.00.1011211346160.26304@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1011211505440.30377@chino.kir.corp.google.com> <20101122005658.GA6710@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Nov 2010, Greg KH wrote:

> > Add an interface to allow new nodes to be added when performing memory
> > hot-add.  This provides a convenient interface to test memory hotplug
> > notifier callbacks and surrounding hotplug code when new nodes are
> > onlined without actually having a machine with such hotpluggable SRAT
> > entries.
> > 
> > This adds a new debugfs interface at /sys/kernel/debug/hotplug/add_node
> 
> The rule for debugfs is "there are no rules", but perhaps you might want
> to name "hotplug" a bit more specific for what you are doing?  "hotplug"
> means pretty much anything these days, so how about s/hotplug/node/
> instead as that is what you are controlling.
> 
> Just a suggestion...
> 

Hmm, how strongly do you feel about that?  There's nothing node specific 
in the memory hotplug code where this lives, so we'd probably have to 
define the dentry elsewhere and even then it would only needed for 
CONFIG_MEMORY_HOTPLUG.

I personally don't see this as a node debugging but rather memory hotplug 
callback debugging.
