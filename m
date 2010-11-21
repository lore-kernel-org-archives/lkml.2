Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab0KUIUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 03:20:04 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:55210 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab0KUIUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 03:20:03 -0500
Date: Sun, 21 Nov 2010 09:19:52 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>
Message-ID: <20101121081951.GK13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <ce13c55a2acb39be7ef5667467c765595df19835.1290087479.git.lasaine@lvk.cs.msu.su>
 <20101120154940.GY13356@enneenne.com>
 <20101121003323.4bbf0199@apollo.gnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101121003323.4bbf0199@apollo.gnet>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 06/17] pps: convert printk/pr_* to dev_*
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 12:33:23AM +0300, Alexander Gordeev wrote:
> ?? Sat, 20 Nov 2010 16:49:40 +0100
> Rodolfo Giometti <giometti@enneenne.com> ??????????:
> 
> > On Thu, Nov 18, 2010 at 07:00:59PM +0300, Alexander Gordeev wrote:
> > > Since we now have direct pointers to struct pps_device everywhere it's
> > > easy to use dev_* functions to print messages instead of plain printks.
> > > Where dev_* cannot be used printks are converted to pr_*.
> > > 
> > > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> > > ---
> > >  drivers/pps/clients/pps-ktimer.c |    5 +++--
> > >  drivers/pps/clients/pps-ldisc.c  |    2 ++
> > >  drivers/pps/kapi.c               |   15 ++++++++-------
> > >  drivers/pps/pps.c                |   25 +++++++++++++------------
> > >  4 files changed, 26 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps-ktimer.c
> > > index 966ead1..2728469 100644
> > > --- a/drivers/pps/clients/pps-ktimer.c
> > > +++ b/drivers/pps/clients/pps-ktimer.c
> > > @@ -19,6 +19,7 @@
> > >   *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > >   */
> > >  
> > > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > 
> > Instead of redefining pr_fmt() in each file you may do it once into
> > include file pps_kernel.h...
> 
> Yes, but then every .c file will have to include linux/pps_kernel.h
> before including linux/kernel.h (where pr_* are defined) and only you
> and me will know the reason for that. Of course, we can add a comment to
> every .c file to discourage others from moving includes but IMHO the
> way how it is done in the patch is better. I dislike hidden
> dependencies between header files very much.

Ok.

Acked-by: Rodolfo Giometti <giometti@linux.it>

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
