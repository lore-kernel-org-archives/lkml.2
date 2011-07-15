Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab1GOFpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:45:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43900 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310Ab1GOFpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:45:19 -0400
Date: Fri, 15 Jul 2011 07:45:12 +0200
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de,
        benh@kernel.crashing.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 2.5/13] memblock: Use __meminit[data] instead of
 __init[data]
Message-ID: <20110715054512.GK3455@htj.dyndns.org>
References: <1310462166-31469-1-git-send-email-tj@kernel.org>
 <20110714094203.GE3455@htj.dyndns.org>
 <CAE9FiQU92k-GAy3DVB4HYpn6D6_u=4T7t9_8FOGh8BLDEAKD=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQU92k-GAy3DVB4HYpn6D6_u=4T7t9_8FOGh8BLDEAKD=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jul 14, 2011 at 02:00:51PM -0700, Yinghai Lu wrote:
> >  #ifdef ARCH_DISCARD_MEMBLOCK
> > -#define __init_memblock __init
> > -#define __initdata_memblock __initdata
> > +#define __init_memblock __meminit
> > +#define __initdata_memblock __meminitdata
> >  #else
> >  #define __init_memblock
> >  #define __initdata_memblock
> 
> that is not good. It will keep memblock.reserved related data and
> functions after boot.
> and those data/func are not used after slab is ready.

Yeah, if MEMORY_HOTPLUG is enabled.  It isn't too big area to begin
with and early_node_map[] and related code removal should offset it.
The problem is that refining different __init tags here is a bit
complex thanks to DISCARD_MEMBLOCK.  We end up having to deal with the
combination of DISCARD_MEMBLOCK and MEMORY_HOTPLUG.  I was hoping that
once we get memblock usage more consistent across different archs, we
could do away with DISCARD_MEMBLOCK.

Thank you.

-- 
tejun
