Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab0CaEwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 00:52:49 -0400
Received: from tundra.namei.org ([65.99.196.166]:43332 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755657Ab0CaEws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 00:52:48 -0400
Date: Wed, 31 Mar 2010 15:49:06 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie
Subject: Config NO_BOOTMEM breaks my amd64 box
Message-ID: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please make NO_BOOTMEM default to n, at least for amd64, where I've found 
that it leads to all kinds of strange, undebuggable boot hangs and errors 
(with relatively current Fedora development userland).

Also, the help text for the item makes little sense to a non-expert in 
this area:


" ---help---
          Use early_res directly instead of bootmem before slab is ready.
                - allocator (buddy) [generic]
                - early allocator (bootmem) [generic]
                - very early allocator (reserve_early*()) [x86]
                - very very early allocator (early brk model) [x86]
          So reduce one layer between early allocator to final allocator."

I had no idea what all this meant, so trusted the default=y and then spent 
several hours wondering why everything was breaking, and would likley not 
have figured it out in linear time without a suggestion from Dave Airlie.


- James
-- 
James Morris
<jmorris@namei.org>
