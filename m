Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117Ab2FOOeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:34:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:49401 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756904Ab2FOOeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:34:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="166126638"
Date: Fri, 15 Jun 2012 22:34:03 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@freedesktop.org>,
        Linus Torvalds <torvalds@ppc970.osdl.org>
Subject: Re: automated warning notifications
Message-ID: <20120615143403.GA18876@localhost>
References: <20120614172523.GB4400@mwanda>
 <20120615014835.GA5695@localhost>
 <20120615071222.GZ13539@mwanda>
 <20120615075810.GA13206@localhost>
 <alpine.DEB.2.02.1206150639130.1864@hadrien>
 <20120615111913.GA13539@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120615111913.GA13539@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:19:14PM +0300, Dan Carpenter wrote:
> On Fri, Jun 15, 2012 at 06:40:51AM -0400, Julia Lawall wrote:
> > > > Eventually I think we will want to set up a mailing list for this or
> > > > we will start sending duplicate messages.
> > >
> > > Fair enough. How can we setup the mailing list? Once the list up, it
> > > would be trivial for me to send sparse warnings out there.
> > 
> > I'm not completely sure that a mailing list would completely eliminate
> > duplicate messages.  But still, it could be the place for people who are
> > interested in seeing such messages to go to, so it seems like a good
> > thing.  I would be happy to contribute content :)
> 
> Yeah.  That might be interesting.  If you don't know whether a bug
> is a false positive or not you could submit it to the list for
> people to look at.
> 
> I don't know if anyone will actually look at them.  I had been
> planning to filter them to a mail box and automatically ignore
> anything that was a duplicate.  But it might actually be worth
> looking at them as well.  Especially if you email had enough useful
> context so I could tell from the message what the bug is.
> 
> Probably we could use something like the attached script to print
> out the line of code which causes the bug and some other script to
> querry git blame and attach the offending commit?

cat -n $code_file | tail -n +$(($lineno - (($context + 1) / 2))) | head -n $(($context + 1))

That's handy, I'll use it to show the source file context for the
first error/warning :-)

Example:

drivers/leds/led-triggers.c: In function ‘led_trigger_event’:
drivers/leds/led-triggers.c:227:3: error: implicit declaration of function ‘led_set_brightness’ [-Werror=implicit-function-declaration]

drivers/leds/led-triggers.c:227:
   224                  struct led_classdev *led_cdev;
   225
   226                  led_cdev = list_entry(entry, struct led_classdev, trig_list);
 > 227                  led_set_brightness(led_cdev, brightness);
   228          }                                                
   229          read_unlock(&trigger->leddev_list_lock);
   230  }

Thanks!
Fengguang
