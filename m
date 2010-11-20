Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0KTSaS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 13:30:18 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:47731 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab0KTSaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 13:30:15 -0500
Date: Sat, 20 Nov 2010 19:30:07 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Joe Perches <joe@perches.com>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Tejun Heo <tj@kernel.org>
Message-ID: <20101120183007.GH13356@enneenne.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <1a1ebcf97b2eb62548c34d2d8fc139c0703a9077.1290087480.git.lasaine@lvk.cs.msu.su>
 <20101120161351.GC13356@enneenne.com>
 <1290272501.27951.27.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290272501.27951.27.camel@Joe-Laptop>
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

On Sat, Nov 20, 2010 at 09:01:41AM -0800, Joe Perches wrote:
> > > -	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
> > > -		dev_err(pps->dev, "unknown event (%x)\n", event);
> > > -		return;
> > > -	}
> > > +	/* check event type */
> > > +	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0);
> > 
> > Ack.
> > 
> > This is a correct usage of BUG_ON. :)
> 
> I don't think that's true.
> 
> /*
>  * Don't use BUG() or BUG_ON() unless there's really no way out; one
>  * example might be detecting data structure corruption in the middle
>  * of an operation that can't be backed out of.  If the (sub)system
>  * can somehow continue operating, perhaps with reduced functionality,
>  * it's probably not BUG-worthy.
>  *
>  * If you're tempted to BUG(), think again:  is completely giving up
>  * really the *only* solution?  There are usually better options, where
>  * users don't need to reboot ASAP and can mostly shut down cleanly.
>  */

If (event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0 then PPS's
data has been corrupted. The PPS subsystem doesn't work correctly even
if the whole system still continues running.

However I already have not acknowledged the patch.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
