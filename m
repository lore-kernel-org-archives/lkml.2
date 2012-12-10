Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab2LJBUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 20:20:43 -0500
Received: from gmmr4.centrum.cz ([46.255.227.253]:37883 "EHLO gmmr4.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430Ab2LJBUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 20:20:42 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Mon, 10 Dec 2012 02:20:38 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121130144427.51A09169@pobox.sk>, <20121130144431.GI29317@dhcp22.suse.cz>, <20121130160811.6BB25BDD@pobox.sk>, <20121130153942.GL29317@dhcp22.suse.cz>, <20121130165937.F9564EBE@pobox.sk>, <20121130161923.GN29317@dhcp22.suse.cz>, <20121203151601.GA17093@dhcp22.suse.cz>, <20121205023644.18C3006B@pobox.sk>, <20121205141722.GA9714@dhcp22.suse.cz>, <20121206012924.FE077FD7@pobox.sk> <20121206095423.GB10931@dhcp22.suse.cz>
In-Reply-To: <20121206095423.GB10931@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121210022038.E6570D37@pobox.sk>
X-Maser: brud
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>There are no other callers AFAICS so I am getting clueless. Maybe more
>debugging will tell us something (the inlining has been reduced for thp
>paths which can reduce performance in thp page fault heavy workloads but
>this will give us better traces - I hope).


Michal,

this was printing so many debug messages to console that the whole server hangs and i had to hard reset it after several minutes :( Sorry but i cannot test such a things in production. There's no problem with one soft reset which takes 4 minutes but this hard reset creates about 20 minutes outage (mainly cos of disk quotas checking). Last logged message:

Dec 10 02:03:29 server01 kernel: [  220.366486] grsec: From 141.105.120.152: bruteforce prevention initiated for the next 30 minutes or until service restarted, stalling each fork 30 seconds.  Please investigate the crash report for /usr/lib/apache2/mpm-itk/apache2[apache2:3586] uid/euid:1258/1258 gid/egid:100/100, parent /usr/lib/apache2/mpm-itk/apache2[apache2:2142] uid/euid:0/0 gid/egid:0/0
