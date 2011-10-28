Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab1J1W5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 18:57:43 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33844 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab1J1W5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 18:57:41 -0400
Subject: Re: [PATCH] kdump: Add udev events for memory online/offline
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: holzheu@linux.vnet.ibm.com, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <20111028154137.1aeb5a6c.akpm@linux-foundation.org>
References: <1319645292.3321.24.camel@br98xy6r>
	 <20111026192449.GE355@redhat.com>
	 <20111027073058.GA2422@osiris.boeblingen.de.ibm.com>
	 <1319707965.2830.1.camel@br98xy6r>
	 <20111028154137.1aeb5a6c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Oct 2011 15:57:16 -0700
Message-ID: <1319842636.23600.186.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11102822-3270-0000-0000-0000014A5667
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 15:41 -0700, Andrew Morton wrote:
> > +     } else if (!strncmp(buf, "offline", min((int)count, 7))) {
> >               ret = memory_block_change_state(mem, MEM_OFFLINE, MEM_ONLINE);
> > -
> > +             if (ret == 0)
> > +                     kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
> > +     }
> 
> ot: what on earth is up with that min() thing which
> Dave-who-doesn't-know-about-min_t added to the strncmp() calls?

My first reaction was, "that's not my code!", but git seems to disagree
with me.  So I'll go and blame it on being young and stupid in 2005.

Reading it, I also think it's probably buggy.

	echo -n "o" > state
 
would be interesting.  I think it'll fall in to the 'online' case.
While probably not that common, it's certainly unexpected.  I'll send a
patch to fix it up.

-- Dave

