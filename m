Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab2EPVxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 17:53:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615Ab2EPVxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 17:53:07 -0400
Date: Wed, 16 May 2012 14:53:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: solmac john <johnsolmac@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-mm <linux-mm@kvack.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kernelnewbies@kernelnewbies.org, linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: [bug] shrink_slab shrinkersize handling
Message-Id: <20120516145303.8a9cb329.akpm@linux-foundation.org>
In-Reply-To: <CAD5x=MPcwXyy0eOdqPxc_8K_i3enoU3ZbtwLS71SHR58FCT6rg@mail.gmail.com>
References: <CAD5x=MPcwXyy0eOdqPxc_8K_i3enoU3ZbtwLS71SHR58FCT6rg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012 14:33:18 +0530
solmac john <johnsolmac@gmail.com> wrote:

> Hi All,
> 
> During mm performance testing sometimes I observed below kernel messages
> 
> [   80.776000] shrink_slab: ashmem_shrink+0x0/0x114 negative objects to
> delete nr=-2133936901
> [   80.784000] shrink_slab: ashmem_shrink+0x0/0x114 negative objects to
> delete nr=-2139256767
> [   80.796000] shrink_slab: ashmem_shrink+0x0/0x114 negative objects to
> delete nr=-2079333971
> [   80.804000] shrink_slab: ashmem_shrink+0x0/0x114 negative objects to
> delete nr=-2096156269
> [   80.812000] shrink_slab: ashmem_shrink+0x0/0x114 negative objects to
> delete nr=-20658392
> 
> ...
>
> I found one patch  http://lkml.org/lkml/2011/8/22/80    for this fix
> Please let me know reason why I am getting above error and above is really
> fix for this problem.  ?

Yes, that patch should fix it.

Aside: I spent some time trying to work out the reason why local
variable `max_pass' in shrink_slab() is called `max_pass' and failed.


