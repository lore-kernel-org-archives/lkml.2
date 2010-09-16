Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab0IPGsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 02:48:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58577 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab0IPGs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 02:48:29 -0400
Message-ID: <56957.91.60.149.91.1284619705.squirrel@www.firstfloor.org>
Date: Thu, 16 Sep 2010 08:48:25 +0200 (CEST)
Subject: Re: [PATCH] x86_64/lib: improve the performance of memmove
From: "Andi Kleen" <andi@firstfloor.org>
To: miaox@cn.fujitsu.com
Cc: "Andi Kleen" <andi@firstfloor.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Ingo Molnar" <mingo@elte.hu>, "Theodore Ts'o" <tytso@mit.edu>,
        "Chris Mason" <chris.mason@oracle.com>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Linux Btrfs" <linux-btrfs@vger.kernel.org>,
        "Linux Ext4" <linux-ext4@vger.kernel.org>
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When the dest and the src do overlap and the memory area is large, memmove
> of
> x86_64 is very inefficient, and it led to bad performance, such as btrfs's
> file
> deletion performance. This patch improved the performance of memmove on
> x86_64
> by using __memcpy_bwd() instead of byte copy when doing large memory area
> copy
> (len > 64).


I still don't understand why you don't simply use a backwards
string copy (with std) ? That should be much simpler and
hopefully be as optimized for kernel copies on recent CPUs.

-Andi


