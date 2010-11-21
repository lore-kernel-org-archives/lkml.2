Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab0KUIhW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 03:37:22 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:45872 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab0KUIhV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 03:37:21 -0500
Date: Sun, 21 Nov 2010 09:37:16 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Message-ID: <20101121083716.GN13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <65eae4de46680aa8d644619f6dc61ba17f1fdc77.1290087479.git.lasaine@lvk.cs.msu.su>
 <20101120160851.GA13356@enneenne.com>
 <20101121022302.2bce2240@apollo.gnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121022302.2bce2240@apollo.gnet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 08/17] pps: add async PPS event handler
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 02:23:02AM +0300, Alexander Gordeev wrote:
> ?? Sat, 20 Nov 2010 17:08:51 +0100
> Rodolfo Giometti <giometti@enneenne.com> ??????????:
> 
> > On Thu, Nov 18, 2010 at 07:01:01PM +0300, Alexander Gordeev wrote:
> > > This handler should be called from an IRQ handler. It uses per-device
> > > workqueue internally.
> > 
> > Can you please explain to me why do you need this patch? Maybe you can
> > add a verbose patch's description? :)
> 
> Well, it's all about optimizing latencies on rt-preempt kernel: if
> everything is done in a process context than we can use mutexes
> (haven't done that yet) and don't disable interrupts, which is better
> for hard real time. I measured that pps_event with kernel consumer
> enabled takes 1-2us on my test machine. Not a big deal, of course...
> 
> Sorry, I've completely forgotten about an echo function. However quick
> look to current clients shows that it is only used in pps-ktimer.c
> for debug printing... Maybe it's not needed at all? I mean, have you
> ever got any user request for this feature? If yes, it can be removed
> IMHO since RFC-2783 says that it's optional. I can handle the removal in
> the next version of the patchset.
> 
> If you don't want it I can have this patch on my rt branch only and
> don't try to push it into mainline.

The echo function is not used as far as I know, so it's ok for me to
remove echo support if you get better performance.

In case we can study how to reimplement it! ;)

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
