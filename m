Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab0IHMTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 08:19:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58467 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab0IHMT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 08:19:29 -0400
Message-ID: <46238.91.60.152.217.1283948365.squirrel@www.firstfloor.org>
Date: Wed, 8 Sep 2010 14:19:25 +0200 (CEST)
Subject: Re: [PATCH V2 1/3] lib: introduce some memory copy macros and 
     functions
From: "Andi Kleen" <andi@firstfloor.org>
To: miaox@cn.fujitsu.com
Cc: "Andi Kleen" <andi@firstfloor.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "Linux Ext4" <linux-ext4@vger.kernel.org>,
        "Linux Btrfs" <linux-btrfs@vger.kernel.org>
User-Agent: SquirrelMail/1.4.11
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> According to the data, the length of the most copies is >=128.

Thanks for the data. Large is easier to optimize than small, that's good.

Could you also measure how many memsets need the backwards copy?
(should be easy to add)

If the number is small that needs backwards then the easiest fix
would be to simply call the normal memcpy in the forward case.

That is for backward could also use a string instruction copy
of course, just have to set the direction flag.

That would be a very small code change.

-Andi


