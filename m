Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630Ab0HJMgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:36:53 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:17805 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757403Ab0HJMgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:36:48 -0400
Message-ID: <4C6147DE.9050608@tilera.com>
Date: Tue, 10 Aug 2010 08:36:46 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <willy@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: perf build broke by list_head changes...
References: <20100809.235746.115919762.davem@davemloft.net>
In-Reply-To: <20100809.235746.115919762.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/10/2010 2:57 AM, David Miller wrote:
> Commit:
>
> commit de5d9bf6541736dc7ad264d2b5cc99bc1b2ad958
> Author: Chris Metcalf <cmetcalf@tilera.com>
> Date:   Fri Jul 2 13:41:14 2010 -0400
>
>     Move list types from <linux/list.h> to <linux/types.h>.
>
> broke the build of 'perf'.
>
> If you move "struct list_head" into types.h, this means perf stops
> building because it depends upon being able to include linux/list.h
> from a userland application and at the same time be able to get the
> basic data types without defining __KERNEL__ or similar.
>   

If necessary, it certainly would be easy to move the list.h types to
follow struct ustat, then bump the #endif up above them with a comment
about the perf system's use of them.

I'm confused, though, since <linux/list.h> isn't installed by
headers_install, so how was perf finding that definition before anyway?

I assume the requirement is something fairly stringent, like parsing
binary data structures out of a memory-mapped region or some such;
normally you wouldn't even want to expose the list_head declaration to
user space.  I haven't looked at the perf subsystem myself yet so I
don't really know.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

