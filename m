Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0DUA27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:28:59 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43496 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab0DUA25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:28:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 21 Apr 2010 09:25:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Larry Woodman <lwoodman@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: repost - RFC [Patch] Remove
 "please try 'cgroup_disable=memory' option if you don't want memory cgroups"
 printk at boot time.
Message-Id: <20100421092502.787371b5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1271773587.28748.134.camel@dhcp-100-19-198.bos.redhat.com>
References: <1271773587.28748.134.camel@dhcp-100-19-198.bos.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 10:26:27 -0400
Larry Woodman <lwoodman@redhat.com> wrote:

> Re-posting, cc'ing linux-mm as requested:
> 
> We are considering removing this printk at boot time from RHEL because
> it will confuse customers, encourage them to change the boot parameters
> and generate extraneous support calls.  Its documented in
> Documentation/kernel-parameters.txt anyway.  Any thoughts???
> 
> Larry Woodman
> 
For RHEL, I agree removing the message makes sense.
But I'm unsure that small machine users, who never use memcg, can notice some
amount of memory are eaten at boot time.

Many distro tends to enable memcg by default and consume memory.

 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
-	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you"
-	" don't want memory cgroups\n");

Hmm.

	printk(KERN_INFO "If you don't want page_cgroup,
			  you can disable this by boot option, cgroup_disable=memory".)

My biggest concern is that we don't have man(5) cgroup as other file systems.
If we have man(5), the best place for this kind of information will be it.
I think most of users will never see kernel-parameter.txt ..

If usual distros are shipped with man(5) cgroup, I agree removing
this in upstream.
(We have man pages for libcgroup but not man(5) for cgroup file system.)

I'm sorry if I don't notice that the latest man package has cgroup section.

Bye,
-Kame

