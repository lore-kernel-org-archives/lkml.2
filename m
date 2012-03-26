Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2CZUNI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:13:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33445 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2CZUNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:13:05 -0400
Date: Mon, 26 Mar 2012 13:13:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Douglas W Jones <jones@cs.uiowa.edu>,
        Michal Nazarewicz <mnazarewicz@google.com>
Subject: Re: [PATCH 1/1] vsprintf: optimize decimal conversion (again)
Message-Id: <20120326131304.018a5f4b.akpm@linux-foundation.org>
In-Reply-To: <CAK1hOcNZ1QdsT2Gajv1y-yAfF85hOTH=18vqqH4itURLtgYfdQ@mail.gmail.com>
References: <201203262047.17865.vda.linux@googlemail.com>
	<201203262051.24271.vda.linux@googlemail.com>
	<20120326125129.78975baf.akpm@linux-foundation.org>
	<CAK1hOcNZ1QdsT2Gajv1y-yAfF85hOTH=18vqqH4itURLtgYfdQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 21:56:38 +0200
Denys Vlasenko <vda.linux@googlemail.com> wrote:

> >> +#if BITS_PER_LONG != 32 || (~(0ULL)>>1) != ((1ULL<<63)-1)
> >
> > What's this for?
> 
> The second check should be just BITS_PER_LONG_LONG != 64,
> but we don't have BITS_PER_LONG_LONG.

So let's add BITS_PER_LONG_LONG rather than hacking around its absence!
