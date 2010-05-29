Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0E2Hi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 03:38:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:34151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab0E2Hix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 03:38:53 -0400
Subject: Re: [Q] perf, x86: should perf_event_x.c being compiled
 conditionally?
From: Peter Zijlstra <peterz@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100528213503.GJ20839@lenovo>
References: <20100528213503.GJ20839@lenovo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 29 May 2010 09:38:57 +0200
Message-ID: <1275118737.27810.12590.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-05-29 at 01:35 +0400, Cyrill Gorcunov wrote:
> Hi,
> 
> while was building the kernel for pretty old laptop I've noticed
> that perf_event_x.c depends on CONFIG_CPU_SUP_ only. So I'm somehow
> confused. Should not some additional condition being used?
> 
> For example if a person have Core 2 or Nehalem machine, he will
> definitely not need p6 and p4 events (yes, they are not _that_ big
> in size, but anyway).
> 
> On the other hands distro builders would prefer to have all compiled in.
> 
> Not sure about what is the best way to resolve this, but perhaps I'm just
> missing some key moment?

We had to split out on the CPU_SUP_* stuff because the AMD support
relies on symbols otherwise not present.

So fixing build dependencies is the main reason we have that.

If you want to extend it, feel free, but be sure to test the
full .config space ;-)
