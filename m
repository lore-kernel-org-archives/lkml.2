Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243Ab2JaRb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:31:58 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50427 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab2JaRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:31:55 -0400
Date: Wed, 31 Oct 2012 18:31:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Borislav Petkov <bp@alien8.de>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add some drop_caches documentation and info messsge
Message-ID: <20121031173154.GA20660@elf.ucw.cz>
References: <20121012125708.GJ10110@dhcp22.suse.cz>
 <20121024210600.GA17037@liondog.tnic>
 <20121024141303.0797d6a1.akpm@linux-foundation.org>
 <1787395.7AzIesGUbB@vostro.rjw.lan>
 <20121024181752.de011615.akpm@linux-foundation.org>
 <alpine.LRH.2.00.1210290958450.10392@twin.jikos.cz>
 <20121029095819.GA4326@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121029095819.GA4326@liondog.tnic>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2012-10-29 10:58:19, Borislav Petkov wrote:
> On Mon, Oct 29, 2012 at 09:59:59AM +0100, Jiri Kosina wrote:
> > You might or might not want to do that. Dropping caches around suspend
> > makes the hibernation process itself faster, but the realtime response
> > of the applications afterwards is worse, as everything touched by user
> > has to be paged in again.

Also note that page-in is slower than  reading hibernation image,
because it is not compressed, and involves seeking.

> Right, do you know of a real use-case where people hibernate, then
> resume and still care about applications response time right afterwards?

Hmm? When I resume from hibernate, I want to use my
machine. *Everyone* cares about resume time afterwards. You move your
mouse, and you don't want to wait for X to be paged-in.

> Besides, once everything is swapped back in, perf. is back to normal,
> i.e. like before suspending.

Kernel will not normally swap anything in automatically. Some people
do swapoff -a; swapon -a to work around that. (And yes, maybe some
automatic-swap-in-when-there's-plenty-of-RAM would be useful.).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
