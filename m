Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2LJKSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:18:22 -0500
Received: from gmmr2.centrum.cz ([46.255.227.252]:56012 "EHLO gmmr2.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677Ab2LJKSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:18:21 -0500
To: =?utf-8?q?Michal_Hocko?= <mhocko@suse.cz>
Subject: =?utf-8?q?Re=3A_=5BPATCH_for_3=2E2=2E34=5D_memcg=3A_do_not_trigger_OOM_from_add=5Fto=5Fpage=5Fcache=5Flocked?=
Date: Mon, 10 Dec 2012 11:18:17 +0100
From: "azurIt" <azurit@pobox.sk>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        =?utf-8?q?cgroups_mailinglist?= <cgroups@vger.kernel.org>,
        =?utf-8?q?KAMEZAWA_Hiroyuki?= <kamezawa.hiroyu@jp.fujitsu.com>,
        =?utf-8?q?Johannes_Weiner?= <hannes@cmpxchg.org>
References: <20121130160811.6BB25BDD@pobox.sk>, <20121130153942.GL29317@dhcp22.suse.cz>, <20121130165937.F9564EBE@pobox.sk>, <20121130161923.GN29317@dhcp22.suse.cz>, <20121203151601.GA17093@dhcp22.suse.cz>, <20121205023644.18C3006B@pobox.sk>, <20121205141722.GA9714@dhcp22.suse.cz>, <20121206012924.FE077FD7@pobox.sk>, <20121206095423.GB10931@dhcp22.suse.cz>, <20121210022038.E6570D37@pobox.sk> <20121210094318.GA6777@dhcp22.suse.cz>
In-Reply-To: <20121210094318.GA6777@dhcp22.suse.cz>
X-Mailer: Centrum Email 5.3
X-Priority: 3
X-Original-From: azurit@pobox.sk
MIME-Version: 1.0
Message-Id: <20121210111817.F697F53E@pobox.sk>
X-Maser: oho
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Hmm, this is _really_ surprising. The latest patch didn't add any new
>logging actually. It just enahanced messages which were already printed
>out previously + changed few functions to be not inlined so they show up
>in the traces. So the only explanation is that the workload has changed
>or the patches got misapplied.


This time i installed 3.2.35, maybe some changes between .34 and .35 did this? Should i try .34?


>> Dec 10 02:03:29 server01 kernel: [  220.366486] grsec: From 141.105.120.152: bruteforce prevention initiated for the next 30 minutes or until service restarted, stalling each fork 30 seconds.  Please investigate the crash report for /usr/lib/apache2/mpm-itk/apache2[apache2:3586] uid/euid:1258/1258 gid/egid:100/100, parent /usr/lib/apache2/mpm-itk/apache2[apache2:2142] uid/euid:0/0 gid/egid:0/0
>
>This explains why you have seen your machine hung. I am not familiar
>with grsec but stalling each fork 30s sounds really bad.


Btw, i never ever saw such a message from grsecurity yet. Will write to grsec mailing list about explanation.


>Anyway this will not help me much. Do you happen to still have any of
>those logged traces from the last run?


Unfortunately not, it didn't log anything and tons of messages were printed only to console (i was logged via IP-KVM). It looked that printing is infinite, i rebooted it after few minutes.


>Apart from that. If my current understanding is correct then this is
>related to transparent huge pages (and leaking charge to the page fault
>handler). Do you see the same problem if you disable THP before you
>start your workload? (echo never > /sys/kernel/mm/transparent_hugepage/enabled)

# cat /sys/kernel/mm/transparent_hugepage/enabled
cat: /sys/kernel/mm/transparent_hugepage/enabled: No such file or directory

# ls -la /sys/kernel/mm                             
total 0
drwx------ 3 root root 0 Dec 10 11:11 .
drwx------ 5 root root 0 Dec 10 02:06 ..
drwx------ 2 root root 0 Dec 10 11:11 cleancache
