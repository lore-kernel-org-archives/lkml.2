Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab2DRFG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 01:06:26 -0400
Received: from sam.nabble.com ([216.139.236.26]:58922 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab2DRFGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 01:06:25 -0400
Message-ID: <33705797.post@talk.nabble.com>
Date: Tue, 17 Apr 2012 22:06:23 -0700 (PDT)
From: Akifumi Chikazawa <chikazawa.akifu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Subject: Re: kernel crash on P4080DS
In-Reply-To: <33544993.post@talk.nabble.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: chikazawa.akifu@jp.fujitsu.com
References: <33544993.post@talk.nabble.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Continue investing, I found a mistake in my last report. 
These sentences are not true.
> This was due to BUG_ON. so I checked the condition.
> But it is not true (it means pte_val(*pt) is 0). 

I guess that the cause of BUG_ON are as follows. There are two cases.
Could you advise me what would cause the kernel panic?

Board       :P2020RDB,P4080DS
Linux kernel:2.6.36.2

Case 1
When ioremap is executed, a part of data of vmap_area that consists of tree
structure had been deleted,
and then, process to find a empty area in ioremap tried to assign an address
already being used.
As the result of that, BUG_ON in mmap_page was executed and caused kernel
panic.


Case2
When ioremap is executed, va_end in vmap_area structure can be 0. va_start
is the correct value at that time.
and process to find an empty area in ioremap did not caluculate accurately.
then it led to an incorrect address.
As the result of that, BUG_ON in mmap_page was executed and caused kernel
panic.
During execution of the immediately preceding ioremap, va_end is not 0.

and I attached Test program for P2020RDB.
http://old.nabble.com/file/p33705797/sample_driver.tar.gz
sample_driver.tar.gz 
-- 
View this message in context: http://old.nabble.com/kernel-crash-on-P4080DS-tp33544993p33705797.html
Sent from the linux-kernel mailing list archive at Nabble.com.

