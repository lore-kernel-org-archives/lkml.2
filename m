Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770Ab1JDPly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 11:41:54 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:52348 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656Ab1JDPlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 11:41:53 -0400
MIME-Version: 1.0
In-Reply-To: <20111004063147.GA12229@sucs.org>
References: <20111004063147.GA12229@sucs.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 4 Oct 2011 16:41:32 +0100
X-Google-Sender-Auth: Z0KsLb4pmH17OGNye-eMVwlUzus
Message-ID: <CAHkRjk7Df9ZX=Uit-q-whVTV7UAwFqeqtbeFCUo=woQE+G5ToA@mail.gmail.com>
Subject: Re: kmemleak and SLAB
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 October 2011 07:31, Sitsofe Wheeler <sitsofe@yahoo.com> wrote:
> When I try to use kmemleak with the SLAB allocator set I receive this
> message when booting 3.1-rc8:
>
> [   28.480569] kmemleak: Cannot allocate a kmemleak_object structure
> [   28.480593] kmemleak: Kernel memory leak detector disabled
> [   34.428037] CPA self-test:
> [   34.435881]  4k 259968 large 0 gb 0 x 259968[b0000000-ef77f000] miss 0
> [   34.447669]  4k 259968 large 0 gb 0 x 259968[b0000000-ef77f000] miss 0
> [   34.458402]  4k 259968 large 0 gb 0 x 259968[b0000000-ef77f000] miss 0
> [   34.458407] ok.
> [   38.754032] wlan0: no IPv6 routers present
> [   67.666048] kmemleak: Automatic memory scanning thread ended
>
> All is fine when using SLUB. On another run I also got an error about an
> ODEBUG oom so I wonder if this is indicative of another problem...

There could be another problem. The kmemleak error says that it could
not allocate the memory required for its internal data keeping. This
happens especially when the allocation is GFP_ATOMIC (it depends on
the context kmemleak is called from).

I have this commit in my tree (not yet pushed upstream):

http://linux-arm.org/git?p=linux-2.6.git;a=commitdiff;h=bcba31f1751bf9d9d1da72dd828dee697d52924f

If you apply this, kmemleak keeps its metadata for later reporting
(well, only if it was fully initialised before the error occured).
This way you can inspect /proc/slabinfo and /proc/meminfo etc. to see
why it ran out of memory.

-- 
Catalin
