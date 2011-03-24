Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab1CXJzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:55:52 -0400
Received: from service87.mimecast.com ([94.185.240.25]:56834 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754108Ab1CXJzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:55:51 -0400
Subject: Re: kmemleak for MIPS
From: Catalin Marinas <catalin.marinas@arm.com>
To: Daniel Baluta <dbaluta@ixiacom.com>
Cc: naveen yadav <yad.naveen@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <AANLkTinnqtXf5DE+qxkTyZ9p9Mb8dXai6UxWP2HaHY3D@mail.gmail.com>
References: <9bde694e1003020554p7c8ff3c2o4ae7cb5d501d1ab9@mail.gmail.com>
	 <AANLkTinnqtXf5DE+qxkTyZ9p9Mb8dXai6UxWP2HaHY3D@mail.gmail.com>
Organization: ARM Limited
Date: Thu, 24 Mar 2011 09:55:40 +0000
Message-ID: <1300960540.32158.13.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 24 Mar 2011 09:55:43.0877 (UTC) FILETIME=[A4170B50:01CBEA09]
X-MC-Unique: 111032409554800601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 09:27 +0000, Daniel Baluta wrote:
> > I want to check kmemleak for both ARM/MIPS. i am able to find kernel
> > patch for ARM at
> > http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg11830.html.
> > But I could not able to trace patch for MIPS.
> 
> It seems that kmemleak is not supported on MIPS.
> 
> According to 'depends on' config entry it is supported on:
> x86, arm, ppc, s390, sparc64, superh, microblaze and tile.
> 
> Cătălin, can you confirm this? I will send a patch to update
> Documentation/kmemleak.txt.
> 
> Also, looking forward to work on making kmemleak available on MIPS.

It's not supported probably because no-one tried it, kmemleak is pretty
architecture-independent. You may need to add some standard symbols to
the vmlinux.lds.S if the linker complains and possibly annotate some
false positives if you get any.

Just add "depends on MIPS" and give it a try.

-- 
Catalin


