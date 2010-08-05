Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267Ab0HEMc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:32:26 -0400
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:43166 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab0HEMcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:32:24 -0400
Date: Thu, 5 Aug 2010 14:31:47 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, john stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>
Message-ID: <20100805123147.GA19407@gundam.enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	john stultz <johnstul@us.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>, Joonwoo Park <joonwpark81@gmail.com>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su> <244e91439eeb1c835b6fa82999fcd65a8a282183.1280952801.git.lasaine@lvk.cs.msu.su> <20100805093236.GI26615@gundam.enneenne.com> <20100805154231.52555130@desktopvm.lvknet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100805154231.52555130@desktopvm.lvknet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv3 05/16] pps: access pps device by direct pointer
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:42:31PM +0400, Alexander Gordeev wrote:
> ?? Thu, 5 Aug 2010 11:32:36 +0200
> Rodolfo Giometti <giometti@enneenne.com> ??????????:
> 
> > On Thu, Aug 05, 2010 at 01:06:42AM +0400, Alexander Gordeev wrote:
> > > Using device index as a pointer needs some unnecessary work to be done
> > > every time the pointer is needed (in irq handler for example).
> > > Using a direct pointer is much more easy (and safe as well).
> > > 
> > > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> [snip]
> > 
> > If you remove these functions you can't be sure anymore that nobodies
> > may call pps_event() over a non existent device...
> 
> [snip]
> 
> > By dropping pps_get_source you may be here by a call from (i.e.) a
> > serial port driver whose doesn't know if your PPS source is gone or
> > not...
> > 
> > I don't understand how your modifications may resolve this problem.
> 
> Well, this can happen only if PPS client module calls pps_event before
> calling pps_register_source() or after pps_unregister_source(). This
> means that it's broken! If we try to handle/workaround broken clients it

Suppose we are using pps-ldisc client. How can you assure that
nobodies may execute pps_tty_close() while you are into the
pps_event() related to the same serial port?

You can't disable serial interrupts in order to avoid
pps_tty_dcd_change calls...

> affects performance. So we have to choose what is the priority:
> security or performance. My guru told me I shouldn't bother too much
> about broken kernel-space code which my code interacts with. If it's
> broken it should be fixed. Some assertions enabled by DEBUG define are
> enough. For me it makes sense but I don't know what should I check here?

I'm sorry but I disagree with you. Kernel code can't allow userland
programs to corrupt it!

We are not discussing about security or performance but about
reliability.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
