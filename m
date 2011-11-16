Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab1KPBPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 20:15:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47175 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757668Ab1KPBPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 20:15:17 -0500
Message-ID: <4EC2FDA9.6050401@jp.fujitsu.com>
Date: Tue, 15 Nov 2011 19:02:49 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: jmarchan@redhat.com
CC: bsingharora@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH V2] Enforce RSS+Swap rlimit
References: <4EB3FA89.6090601@redhat.com> <4EC264AA.30306@redhat.com>
In-Reply-To: <4EC264AA.30306@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/15/2011 8:10 AM, Jerome Marchand wrote:
> 
> Change since V1: rebase on 3.2-rc1
> 
> Currently RSS rlimit is not enforced. We can not forbid a process to exceeds
> its RSS limit and allow it swap out. That would hurts the performance of all
> system, even when memory resources are plentiful.
> 
> Therefore, instead of enforcing a limit on rss usage alone, this patch enforces
> a limit on rss+swap value. This is similar to memsw limits of cgroup.
> If a process rss+swap usage exceeds RLIMIT_RSS max limit, he received a SIGBUS
> signal. 

No good idea.
 - RLIMIT_RSS has clear definition and this patch break it. you should makes
   another rlimit at least.
 - SIGBUS can be ignored. rlimit shouldn't ignorable.


