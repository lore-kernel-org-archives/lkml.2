Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab2DBWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:16:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44847 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2DBWQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:16:55 -0400
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
In-Reply-To: <4F77C75B.4060105@intel.com>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
	 <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>
	 <1333163902.2960.63.camel@laptop>  <4F77C75B.4060105@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Apr 2012 00:16:48 +0200
Message-ID: <1333405008.2960.84.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-01 at 11:11 +0800, Yan, Zheng wrote:
> > So what's up with all this box->lock business.. why does that lock
> > exist?
> 
> If user doesn't provide the "-C x" option to the perf tool, multiple cpus
> will try adding/deleting events at the same time. 

Right, however:

> > Aside from all this, there's still the problem that you don't place all
> > events for a particular phys_id onto a single cpu. It doesn't matter
> > which cpu in that package it is, but all events should go to the same.
> > 
> > This means that on unplug of that cpu, you have to migrate all these
> > events etc..
> 
> Any hints how to do this. I'm afraid it requires big changes to perf core.

Yes it'll need some core changes, but I don't think I'll be too bad,
I'll try and write up something soonish.. 

