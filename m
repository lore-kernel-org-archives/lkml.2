Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab0LABCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:02:51 -0500
Received: from kroah.org ([198.145.64.141]:59748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab0LABCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:02:34 -0500
Date: Tue, 30 Nov 2010 16:58:51 -0800
From: Greg KH <greg@kroah.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, akpm@linux-foundation.org,
        ying.huang@intel.com, Borislav Petkov <bp@alien8.de>,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC] persistent store (version 2) (part 1 of 2)
Message-ID: <20101201005851.GA31571@kroah.com>
References: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 04:20:50PM -0800, Luck, Tony wrote:
> Here's version 2 with most of the fixes suggested in the discussion
> for version 1 (see http://marc.info/?l=linux-arch&m=129045078803118&w=2).
> 
> Stuff that I haven't done:
> 
> 1) Still has the "daft" echo filename > erase to clear entries from the
> persistent store.  I looked hard at /sys and can't see how to get a
> notification for an unlink(2). If I'm missing something, would somebody
> please send me a clue. If this is a fatal flaw - then this will have to
> move to debugfs (or turn into its own filesystem type). But I'd really
> prefer to not give up the convenience of /sys
> 
> 2) Did not implement Jim's suggestion to save OOPs ... I'm not at
> all sure how to let the user configure this. mtdoops.c has a module
> parameter for it - but I gave up on letting pstore be a module ...
> it needs to be initialized before the platform driver, and there doesn't
> seem to be much point in having it be unloadable.
> 
> I did write the ERST platform hooks (they are part 2 of 2, but I'd advise
> the faint of heart not to look too closely at the ACPI/APEI'isms involved).
> Here's a sample of what it looks like (with a debug call to panic() from
> the pstore_erase() function added for testing purposes):
> 
> $ cd /sys/firmware/pstore

As you are adding new sysfs files, you are required to document them in
Documentation/ABI/ as well.

thanks,

greg k-h
