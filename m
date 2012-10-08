Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab2JHPks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:40:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab2JHPkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:40:42 -0400
Date: Mon, 8 Oct 2012 17:38:56 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        wey-yi.w.guy@intel.com, ilw@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: iwl3945: order 5 allocation during ifconfig up; vm problem?
Message-ID: <20121008153855.GA9737@redhat.com>
References: <20120909213228.GA5538@elf.ucw.cz>
 <alpine.DEB.2.00.1209091539530.16930@chino.kir.corp.google.com>
 <20120910111113.GA25159@elf.ucw.cz>
 <20120911162536.bd5171a1.akpm@linux-foundation.org>
 <20120912101826.GL11266@suse.de>
 <20121003113659.GD2259@redhat.com>
 <alpine.DEB.2.00.1210031104120.29765@chino.kir.corp.google.com>
 <20121005083659.GA2819@redhat.com>
 <20121006120850.GB18025@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121006120850.GB18025@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 02:08:50PM +0200, Pavel Machek wrote:
> On Fri 2012-10-05 10:37:00, Stanislaw Gruszka wrote:
> > On Wed, Oct 03, 2012 at 11:07:13AM -0700, David Rientjes wrote:
> > > On Wed, 3 Oct 2012, Stanislaw Gruszka wrote:
> > > 
> > > > So, can this problem be solved like on below patch, or I should rather
> > > > split firmware loading into chunks similar like was already iwlwifi did?
> > 
> > Hmm, I looked at iwl3945 code and looks loading firmware in chunks is
> > nothing that can be easily done. 3945 bootstrap code expect that runtime
> > ucode will be placed in physically continue memory, and there are no
> > separate instructions for copy and for execute, just one to perform both
> > those actions. Maybe loading firmware in chunks can be done using
> > undocumented features of the device, but I'm eager to do this.
> 
> Just allocate memory during boot?

On driver I can reserve memory during module load, but also this isn't
something I prefer to do.
 
> > Pavel, do you still can reproduce this problem on released 3.6 ? 
> 
> It happened again yesterday on 3.6.0-rc6+. I don't think mm changed
> between -rc6 and final...

Could you check  __GFP_REPEAT oneline patch posted previously ?
And if that fail again, provide full dmesg (on your previous messages
there is vmap() failure, which I do not understand, where it come
from) ?

Thanks
Stanislaw
