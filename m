Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab1J1FRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 01:17:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45380 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab1J1FRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 01:17:19 -0400
Message-ID: <4EAA3ADC.4030501@vflare.org>
Date: Fri, 28 Oct 2011 01:17:16 -0400
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, levinsasha928@gmail.com,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
In-Reply-To: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On 10/27/2011 02:52 PM, Dan Magenheimer wrote:

> Hi Linus --
> 
> Frontswap now has FOUR users: Two already merged in-tree (zcache
> and Xen) and two still in development but in public git trees
> (RAMster and KVM).  Frontswap is part 2 of 2 of the core kernel
> changes required to support transcendent memory; part 1 was cleancache
> which you merged at 3.0 (and which now has FIVE users).
>


I think frontswap would be really useful. Without this, zcache would be
limited to compressed caching just the page cache pages but with
frontswap, we can balance out compressed memory usage between swap cache
and page cache pages. It also provides many advantages over existing
solutions like zram which presents a fixed size virtual (compressed)
block device interface. Since fronstwap doesn't have to "pretend" as a
block device, it can incorporate many dynamic resizing policies, a
critical factor for compressed caching.

Thanks,
Nitin
