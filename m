Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1LTVgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 16:36:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52799 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1LTVgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 16:36:03 -0500
Date: Tue, 20 Dec 2011 13:36:00 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Android low memory killer vs. memory pressure notifications
In-Reply-To: <20111220145654.GA26881@oksana.dev.rtsoft.ru>
Message-ID: <alpine.DEB.2.00.1112201322170.22077@chino.kir.corp.google.com>
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru> <20111219121255.GA2086@tiehlicka.suse.cz> <alpine.DEB.2.00.1112191110060.19949@chino.kir.corp.google.com> <20111220145654.GA26881@oksana.dev.rtsoft.ru>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Dec 2011, Anton Vorontsov wrote:

> Hm, assuming that metadata is no longer an issue, why do you think avoiding
> cgroups would be a good idea?
> 

It's helpful for certain end users, particularly those in the embedded 
world, to be able to disable as many config options as possible to reduce 
the size of kernel image as much as possible, so they'll want a minimal 
amount of kernel functionality that allows such notifications.  Keep in 
mind that CONFIG_CGROUP_MEM_RES_CTLR is not enabled by default because of 
this (enabling it, CONFIG_RESOURCE_COUNTERS, and CONFIG_CGROUPS increases 
the size of the kernel text by ~1%), and it's becoming increasingly 
important for certain workloads to be notified of low memory conditions 
without any restriction on its usage other than the amount of RAM that the 
system has so that they can trigger internal memory freeing, explicit 
memory compaction from the command line, drop caches, reducing scheduling 
priority, etc.
