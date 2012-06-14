Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2FNJtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:49:35 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60295 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115Ab2FNJte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:49:34 -0400
Message-ID: <1339667440.3321.7.camel@lappy>
Subject: Re: Early boot panic on machine with lots of memory
From: Sasha Levin <levinsasha928@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, hpa@linux.intel.com,
        linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 14 Jun 2012 11:50:40 +0200
In-Reply-To: <20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1339623535.3321.4.camel@lappy>
	 <20120614032005.GC3766@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-14 at 12:20 +0900, Tejun Heo wrote:
> On Wed, Jun 13, 2012 at 11:38:55PM +0200, Sasha Levin wrote:
> > Hi all,
> > 
> > I'm seeing the following when booting a KVM guest with 65gb of RAM, on latest linux-next.
> > 
> > Note that it happens with numa=off.
> > 
> > [    0.000000] BUG: unable to handle kernel paging request at ffff88102febd948
> > [    0.000000] IP: [<ffffffff836a6f37>] __next_free_mem_range+0x9b/0x155
> 
> Can you map it back to the source line please?

mm/memblock.c:583

                        phys_addr_t r_start = ri ? r[-1].base + r[-1].size : 0;
  97:   85 d2                   test   %edx,%edx
  99:   74 08                   je     a3 <__next_free_mem_range+0xa3>
  9b:   49 8b 48 f0             mov    -0x10(%r8),%rcx
  9f:   49 03 48 e8             add    -0x18(%r8),%rcx

It's the deref on 9b (r8=ffff88102febd958).

