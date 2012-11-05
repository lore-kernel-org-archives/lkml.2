Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2KEVo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:44:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab2KEVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:44:57 -0500
Date: Mon, 5 Nov 2012 13:44:56 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        linux-mm@kvack.org, Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Ying Han <yinghan@google.com>
Subject: Re: [PATCH 1/2] mm: Export vm_committed_as
Message-Id: <20121105134456.f655b85a.akpm@linux-foundation.org>
In-Reply-To: <426367E2313C2449837CD2DE46E7EAF930DF7FBB@SN2PRD0310MB382.namprd03.prod.outlook.com>
References: <1349654347-18337-1-git-send-email-kys@microsoft.com>
	<1349654386-18378-1-git-send-email-kys@microsoft.com>
	<20121008004358.GA12342@kroah.com>
	<426367E2313C2449837CD2DE46E7EAF930A1FB31@SN2PRD0310MB382.namprd03.prod.outlook.com>
	<20121008133539.GA15490@kroah.com>
	<20121009124755.ce1087b4.akpm@linux-foundation.org>
	<426367E2313C2449837CD2DE46E7EAF930DF7FBB@SN2PRD0310MB382.namprd03.prod.outlook.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Nov 2012 14:09:38 +0000
KY Srinivasan <kys@microsoft.com> wrote:

> 
> 
> > >
> > > Ok, but you're going to have to get the -mm developers to agree that
> > > this is ok before I can accept it.
> > 
> > Well I guess it won't kill us.
> 
> Andrew,
> 
> I presumed this was an Ack from you with regards to exporting the
> symbol. Looks like Greg is waiting to hear from you before he can check
> these patches in. Could you provide an explicit Ack.
> 

Well, I do have some qualms about exporting vm_committed_as to modules.

vm_committed_as is a global thing and only really makes sense in a
non-containerised system.  If the application is running within a
memory cgroup then vm_enough_memory() and the global overcommit policy
are at best irrelevant and misleading.

If use of vm_committed_as is indeed a bad thing, then exporting it to
modules might increase the amount of badness in the kernel.


I don't think these qualms are serious enough to stand in the way of
this patch, but I'd be interested in hearing the memcg developers'
thoughts on the matter?


Perhaps you could provide a detailed description of why your module
actually needs this?  Precisely what information is it looking for
and why?  If we know that then perhaps a more comfortable alternative
can be found.
