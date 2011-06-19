Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab1FSRy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 13:54:29 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:37655 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752509Ab1FSRy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 13:54:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=K64UGwAp+Gxq9Ps3P1zgO2ZQ4d9wRGK9893gZntGGjfDRmLlv68oW7G84wcM6/afJQoGvKfvyKI7aUom6mjqongxkLN+sMPE5gWw0/DoTczL9tT5JYbQf8vytv+gSmV7;
Date: Sun, 19 Jun 2011 10:47:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: 37573e8c (cgroup fix) causing implicit declaration of function
 'node_start_pfn'
Message-Id: <20110619104744.9cd631c1.rdunlap@xenotime.net>
In-Reply-To: <20110619151214.GF2031@gallifrey>
References: <20110619151214.GF2031@gallifrey>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Jun 2011 16:12:14 +0100 Dr. David Alan Gilbert wrote:

> Hi,
>   The current git head is failing to build for me with:
> 
> mm/page_cgroup.c: In function 'page_cgroup_init':
> mm/page_cgroup.c:308:3: error: implicit declaration of function 'node_start_pfn'
> mm/page_cgroup.c:309:3: error: implicit declaration of function 'node_end_pfn'
> 
> this is for a very basic 32bit x86 build, and it looks like
> include/asm/mmzone_32.h only defines node_start_pfn and node_end_pfn on
> CONFIG_DISCONTIGMEM - which I have off.
> 
> The use of node_start_pfn seems to be from 
> 
>   commit 37573e8c718277103f61f03741bdc5606d31b07e
>   Author: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>   Date:   Wed Jun 15 15:08:42 2011 -0700
> 
>      memcg: fix init_page_cgroup nid with sparsemem

Please see if http://marc.info/?l=linux-kernel&m=130827204306775&w=2
fixes it for you.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
