Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab0EKUZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 16:25:56 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:60213 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0EKUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 16:25:54 -0400
Date: Tue, 11 May 2010 15:21:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
In-Reply-To: <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1005111520260.1500@router.home>
References: <1273487642-2169-1-git-send-email-os@emlix.com>  <20100510142225.4bf215ef.akpm@linux-foundation.org> <20100511060547.GA9644@core.coreip.homeip.net>  <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com>  <20100511062110.GB9644@core.coreip.homeip.net>
 <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com>  <20100511063309.GC9644@core.coreip.homeip.net> <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>  <AANLkTinV79HZqS1cktHDsTsHDel-0Nti_Uk4i7mGaRiK@mail.gmail.com> 
 <1273608441.15067.1002.camel@calx> <AANLkTimt-eRCt_HTq7OUwzG1dgRuzJHk1tlgOcq4ocL7@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Mike Frysinger wrote:

> and like i said, that doesnt sound like a reasonable solution when
> every single SPI driver (over 100 atm) out there is affected

If you are on an embedded arch then you can of course set the default
kmalloc alignment.

The requirement for kmalloc is that it returns memory that can be used for
DMA. If the arch can only DMA into cacheline aligned objects then the
correct method is to force kmalloc alignment to cacheline size.

