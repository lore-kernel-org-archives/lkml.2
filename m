Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab0KAMsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 08:48:47 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:45449 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab0KAMsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 08:48:45 -0400
Message-ID: <4CCEB723.2010005@kernel.dk>
Date: Mon, 01 Nov 2010 08:48:35 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
        Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] Optimize relay_alloc_page_array() slightly by using 
 vzalloc rather than vmalloc and memset
References: <alpine.LNX.2.00.1010302216550.1572@swampdragon.chaosbits.net> <20101030214704.GA20005@Krystal>
In-Reply-To: <20101030214704.GA20005@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-30 17:47, Mathieu Desnoyers wrote:
> BLK_DEV_IO_TRACE seems to still select RELAY. Has it completed its
> transition to either Ftrace or Perf ? Depending on Jens, moving blktrace
> relay dependency to the Generic Ring Buffer Library might be a good
> option to consider.

The blktrace user bits is still (by far) the most wide spread way that
blktrace is used in the field, and those still rely on relayfs. So no,
we can't kill it now.

-- 
Jens Axboe

