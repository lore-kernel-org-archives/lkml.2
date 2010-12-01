Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab0LASlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:41:35 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52854 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab0LASle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:41:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kOEdIDSvXrH8xn+ITyn2VRMz6IHBkOoKkJN9/Me+1tDSg98+hjAo1ti6F6Ijm8oHIq
         aW6X1DsQEoFpL0Us05NeRY52NDm87a86FvKBuUhAevm+Dy/Q8A1Bb7E4TVp8xWotX/7R
         iBPWSytCXlhyGB7gKsQd9rGvDSZQqQB1yewV8=
Date: Wed, 1 Dec 2010 21:41:28 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] x86, NMI: Remove DIE_NMI_IPI and add priorties to
	handlers
Message-ID: <20101201184128.GB6478@lenovo>
References: <1291156050-4482-1-git-send-email-dzickus@redhat.com> <1291156050-4482-5-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291156050-4482-5-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 05:27:25PM -0500, Don Zickus wrote:
> When re-ordering how the NMI handles its callbacks, a conversation started
> asking what DIE_NMI_IPI meant.  No one could answer it.

It should have came from commit

 | commit c4b2bffee2a4115fed2825530f2b906ee2f17bd7
 | Author: Andi Kleen <ak@suse.de>
 | Date:   Fri Jan 23 18:46:40 2004 -0800
 |
 |   [PATCH] x86-64 merge
 |   
 |   Mainly lots of bug fixes and a few minor features. One change is that
 |   it uses drivers/Kconfig now like i386. This requires a few minor changes in
 |   outside Kconfig files which I am sending separately.
 ...

Andi do you remember what the initial idea was? Didn't find any user of it
even in this old commit. Just curious.

> 
> Noticing that is was wasteful to call the die_chain a second time with just
> another argument, DIE_NMI_IPI, it was decided to nuke it and add priorities
> to the die_chain handlers to maintain existing behaviour.
> 
> This patch replaces DIE_NMI_IPI with the appropriate option, mostly DIE_NMI.
> Then it adds priorities to those handlers, using a globally defined set of
> priorities for NMI.
> 
> The thought is eventually we will just switch the nmi handlers from the
> die_chain to something more nmi specific.
> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---

 Don, maybe switching to say new chains like chain_perf and friends would be
more readable/clean? I'm not against this patch by any means, but just a thought ;)

 Ie I thought like

 default_do_nmi
   if (!(reason & 0xc0)) {
     if (notify_perf() == NOTIFY_STOP)
       return
     if (notify_die() == NOTIFY_STOP)
       return
    ...
   }

 Or there is something obvious I'm missing?

 Again, just a thought.

 Cyrill
