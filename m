Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab1EBVzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:55:45 -0400
Received: from kroah.org ([198.145.64.141]:38983 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758213Ab1EBVzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:55:43 -0400
Date: Mon, 2 May 2011 14:55:35 -0700
From: Greg KH <greg@kroah.com>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [RFC 1/5] platform-drivers-x86: add support for Technologic
 Systems TS-5xxx detection
Message-ID: <20110502215535.GA30373@kroah.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
 <1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com>
 <20110429233230.GB24864@kroah.com>
 <1304368433-sup-4264@sfl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304368433-sup-4264@sfl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 02, 2011 at 05:07:29PM -0400, Vivien Didelot wrote:
> Hi,
> 
> Thanks you all for your comments, I'll consider them carefully.
> 
> Excerpts from Greg KH's message of 2011-04-29 19:32:30 -0400:
> > On Fri, Apr 29, 2011 at 06:21:48PM -0400, Vivien Didelot wrote:
> > > +/proc filesystem
> > > +----------------
> > > +
> > > +Information about the TS board is available through the /proc/ts-sbcinfo.
> > 
> > Really?  Why?
> > 
> > As you now have added a new kernel/user ABI, it must be documented in
> > Documentation/ABI/
> > 
> > Please include that in your next patch.
> > 
> > But first off, why a new proc file?  What is it used for?
> 
> I think it could be useful for the user to know what option is available
> or not on the board.

But that's not how we export data to userspace anymore, sorry.  We try
to learn from our past mistakes.

Almost all of this data can be gotten from other methods anyway, you
need to justify why you wish to repeat this here.

> > > +static int ts_sbcinfo_init_buffer(char *buf, struct ts5xxx_sbcinfo *sbcinfo)
> > > +{
> > > +    char *pos = buf;
> > > +
> > > +    pos += ts_addbuf(pos, "Board ID", "TS-%d", sbcinfo->board_id);
> > > +    pos += ts_addbuf(pos, "RS485", "%s", sbcinfo->rs485 ? "yes" : "no");
> > > +    pos += ts_addbuf(pos, "AnalogToDigital", "%s",
> > > +             sbcinfo->adc ? "yes" : "no");
> > > +    pos += ts_addbuf(pos, "Auto485", "%s", sbcinfo->auto485 ? "yes" : "no");
> > > +    pos += ts_addbuf(pos, "SRAM", "%s", sbcinfo->sram ? "yes" : "no");
> > > +    pos += ts_addbuf(pos, "External Reset", "%s",
> > > +             sbcinfo->external_reset ? "yes" : "no");
> > 
> > Most of these look like they should be simple "one value per file" sysfs
> > files for your system.  That would make things much easier on your
> > userspace tools to handle parsing them properly, right?
> > 
> > Why not do that instead?
> 
> I had a look at other drivers, and /sys/devices/platform/ts/ seems to be
> a good place to hold those entries (one per options as you suggested).
> Do you agree with that?

No, this is not a platform device, is it?  Only platform devices go
there, and I really doubt you have many of them for this board.

> By the way, as they would be sysfs attributes, is Documentation/ABI the
> best place to add the documentation file?

Yes.

thanks,

greg k-h
