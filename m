Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab0F1JDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 05:03:44 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:41372 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab0F1JDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 05:03:41 -0400
Message-ID: <4C286568.60901@orcon.net.nz>
Date: Mon, 28 Jun 2010 21:03:36 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mattst88@gmail.com,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       rth@twiddle.net, ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
       alexdeucher@gmail.com, jglisse@redhat.com
Subject: Re: Problems with alpha/pci + radeon/ttm
References: <20100622145805R.fujita.tomonori@lab.ntt.co.jp>	<AANLkTilMfDfy7BPiuAh9u-tR3kw1Vt_SebMziLUtLM6S@mail.gmail.com>	<4C232AAC.2010200@orcon.net.nz>	<20100627131836T.fujita.tomonori@lab.ntt.co.jp>	<4C272C1C.9000802@orcon.net.nz> <AANLkTinrscp_Vqh69dbH5t5yqNiR4Mgl7T2JRrmWwI4a@mail.gmail.com>
In-Reply-To: <AANLkTinrscp_Vqh69dbH5t5yqNiR4Mgl7T2JRrmWwI4a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Mon, 28 Jun 2010 21:03:38 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Jun 28 21:03:38 2010
X-DSPAM-Confidence: 0.7618
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/10 11:14, Dave Airlie wrote:
> The bus error is caused by the kernel, its something alpha specific
> with how mmap works,
> I'm not sure if alpha needs some special mmap flags or something,

Neither am I.  All I know is that Alpha reorders CPU instructions more 
aggressively than most other architectures, the page map size is 8kB, 
and memory accesses must be aligned to the datum size.

Maybe Ivan or Richard can comment on any relevant Alpha mmap specific 
issues.

BTW, I discovered a couple of weeks ago that DRI is broken under UMS. 
It was working a year or so ago so something has happened to it.  Am I 
correct in thinking that the DRM code has pretty much been shifted into 
the kernel even for UMS?

On the Alpha I have been testing on (PWS600au, EV56 cpu and a radeon 
RV710 graphics card) running glxgears under UMS displays artefacts in 
rendering the gears, that is, some facets are not clipped to the 
rotating gear but extend to the edge of the window.  On another Alpha 
(XP1000, EV67 cpu and a radeon RV610 card) it locked up completely 
(couldn't even ping it) when I ran glxgears.  They are both running 
Debian unstable.

Cheers
Michael.
