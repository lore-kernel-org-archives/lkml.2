Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab2AYAWb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:22:31 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:63916 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2AYAWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:22:30 -0500
Message-ID: <1327450945.14373.24.camel@edumazet-laptop>
Subject: Re: [PATCH v2] proc:  speedup /proc/stat handling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Paul Tuner <pjt@google.com>
Date: Wed, 25 Jan 2012 01:22:25 +0100
In-Reply-To: <20120124161221.032325d1.akpm@linux-foundation.org>
References: <1327075164.12389.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <1327449683.14373.12.camel@edumazet-laptop>
	 <20120124161221.032325d1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 24 janvier 2012 à 16:12 -0800, Andrew Morton a écrit :

> Did you measure the improvement from this patch?

Unfortunately I can not reboot the server where I noticed this
performance problem.

On the smaller one, performance improvement is about 20%, because the
second run of show_stat() can use data present in cpu cache.

On big machines, I guess the 128 bytes per possible cpu reservation can
avoid the second run. (since a typical cpuXXX line is smaller than 128
bytes)



