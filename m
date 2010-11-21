Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab0KUImY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 03:42:24 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:34015 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab0KUImX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 03:42:23 -0500
Date: Sun, 21 Nov 2010 09:42:19 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Tejun Heo <tj@kernel.org>
Message-ID: <20101121084218.GP13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <1a1ebcf97b2eb62548c34d2d8fc139c0703a9077.1290087480.git.lasaine@lvk.cs.msu.su>
 <20101120161351.GC13356@enneenne.com>
 <1290272501.27951.27.camel@Joe-Laptop>
 <20101121034008.4fef543a@apollo.gnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121034008.4fef543a@apollo.gnet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 10/17] pps: use BUG_ON for kernel API safety checks
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 03:40:08AM +0300, Alexander Gordeev wrote:
> ?? Sat, 20 Nov 2010 09:01:41 -0800
> Joe Perches <joe@perches.com> ??????????:
> 
> > On Sat, 2010-11-20 at 17:13 +0100, Rodolfo Giometti wrote:
> > > On Thu, Nov 18, 2010 at 07:01:03PM +0300, Alexander Gordeev wrote:
> > > > This way less overhead is involved when running production kernel.
> > > > If you want to debug a pps client module please define DEBUG to enable
> > > > the checks.
> > > > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > []
> > > > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> > > > @@ -179,10 +168,8 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
> > > >  	int captured = 0;
> > > >  	struct pps_ktime ts_real;
> > > >  
> > > > -	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
> > > > -		dev_err(pps->dev, "unknown event (%x)\n", event);
> > > > -		return;
> > > > -	}
> > > > +	/* check event type */
> > > > +	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
> > > 
> > > Ack.
> > > 
> > > This is a correct usage of BUG_ON. :)
> > 
> > I don't think that's true.
> > 
> > /*
> >  * Don't use BUG() or BUG_ON() unless there's really no way out; one
> >  * example might be detecting data structure corruption in the middle
> >  * of an operation that can't be backed out of.  If the (sub)system
> >  * can somehow continue operating, perhaps with reduced functionality,
> >  * it's probably not BUG-worthy.
> >  *
> >  * If you're tempted to BUG(), think again:  is completely giving up
> >  * really the *only* solution?  There are usually better options, where
> >  * users don't need to reboot ASAP and can mostly shut down cleanly.
> >  */
> 
> Hmm, didn't check that before. What is more appropriate in this
> situation?

IMHO here you can use BUG_ON() but not into pps_register_source().

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
