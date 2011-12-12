Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab1LLKSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:18:53 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab1LLKSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:18:50 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
Date: Mon, 12 Dec 2011 11:20:16 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, gregkh@suse.de,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu
References: <20111210104341.592561407@chello.nl> <1323680078.16764.45.camel@twins> <CACVXFVPOsUrEEDT=iMZyrvaX3G_XqWpVOJyz24=FPTtB_9J9HQ@mail.gmail.com>
In-Reply-To: <CACVXFVPOsUrEEDT=iMZyrvaX3G_XqWpVOJyz24=FPTtB_9J9HQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112121120.16326.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. Dezember 2011, 10:57:31 schrieb Ming Lei:
> On Mon, Dec 12, 2011 at 4:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, 2011-12-12 at 11:48 +0800, Ming Lei wrote:
> >> For kref, maybe it is still multiple operations done on one cpu vs them
> >> being visible on another, but seems a bit implicit, see the common kref
> >> usage below:
> >>
> >> CPU0                            CPU1
> >>                                         A:kref_init(&obj->ref)
> >
> > how does CPU0 get a ref to obj?
> 
> Suppose open/close/read/.. context is run on CPU0, and driver .probe/.release
> context(hotplug context) is run on CPU1. There are a few examples on
> usb driver(eg. usb-skeleton.c, ...)

USB generally relies on an implied barrier just as:

        /* we can register the device now, as it is ready */
        retval = usb_register_dev(interface, &skel_class);

Generally reference counting cannot help you if kfree() is involved

	Regards
		Oliver
