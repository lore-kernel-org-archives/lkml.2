Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab0GHWcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 18:32:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45995 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab0GHWcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 18:32:11 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       jeremy@goop.org
Subject: Re: GSoC 2010 - Migration from memory ballooning to memory hotplug in Xen
References: <20100708194553.GA30124@router-fw-old.local.net-space.pl>
Date: Fri, 09 Jul 2010 00:32:05 +0200
In-Reply-To: <20100708194553.GA30124@router-fw-old.local.net-space.pl> (Daniel
	Kiper's message of "Thu, 8 Jul 2010 21:45:53 +0200")
Message-ID: <871vbdr4ey.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kiper <dkiper@net-space.pl> writes:
>
> OK, let's go to details. When I was playing with Xen I saw that
> ballooning does not give possibility to extend memory over boundary
> declared at the start of system. Yes, I know that is by desing however
> I thought that it is a limitation which could by very annoing in some
> enviroments (I think especially about servers). That is why I decided to
> develop some code which remove that one. At the beggining I thought
> that it should be replaced by memory hotplyg however after some test
> and discussion with Jeremy we decided to link balooning (for memory
> removal) with memory hotplug (for extending memory above boundary
> declared at the startup of system). Additionaly, we decided to implement
> this solution for Linux Xen gustes in all forms (PV/i386,x86_64 and
> HVM/i386,x86_64).

While you can do that the value is not very large because you
could just start the guests with more memory, but ballooned in 
the first place (so that they don't actually use it) 

The only advantage of using memory hotadd is that the mem_map doesn't
need to be pre-allocated, but that's only a few percent of the memory.

So it would only help if you want to add gigantic amounts of memory
to a VM (like >20-30x of what it already has).

One trap is also that memory hotadd is a frequent source of regressions,
so you'll likely run into existing bugs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
