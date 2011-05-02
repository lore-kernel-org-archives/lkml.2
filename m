Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017Ab1EBVHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:07:34 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:60178 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1EBVHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:07:32 -0400
Content-Type: text/plain; charset=UTF-8
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jonas Fonseca <jonas.fonseca@savoirfairelinux.com>,
        platform-driver-x86 <platform-driver-x86@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [RFC 1/5] platform-drivers-x86: add support for Technologic Systems TS-5xxx detection
In-reply-to: <20110429233230.GB24864@kroah.com>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com> <1304115712-5299-2-git-send-email-vivien.didelot@savoirfairelinux.com> <20110429233230.GB24864@kroah.com>
Date: Mon, 02 May 2011 17:07:29 -0400
Message-Id: <1304368433-sup-4264@sfl>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks you all for your comments, I'll consider them carefully.

Excerpts from Greg KH's message of 2011-04-29 19:32:30 -0400:
> On Fri, Apr 29, 2011 at 06:21:48PM -0400, Vivien Didelot wrote:
> > +/proc filesystem
> > +----------------
> > +
> > +Information about the TS board is available through the /proc/ts-sbcinfo.
> 
> Really?  Why?
> 
> As you now have added a new kernel/user ABI, it must be documented in
> Documentation/ABI/
> 
> Please include that in your next patch.
> 
> But first off, why a new proc file?  What is it used for?

I think it could be useful for the user to know what option is available
or not on the board.

> 
> > +static int ts_sbcinfo_init_buffer(char *buf, struct ts5xxx_sbcinfo *sbcinfo)
> > +{
> > +    char *pos = buf;
> > +
> > +    pos += ts_addbuf(pos, "Board ID", "TS-%d", sbcinfo->board_id);
> > +    pos += ts_addbuf(pos, "RS485", "%s", sbcinfo->rs485 ? "yes" : "no");
> > +    pos += ts_addbuf(pos, "AnalogToDigital", "%s",
> > +             sbcinfo->adc ? "yes" : "no");
> > +    pos += ts_addbuf(pos, "Auto485", "%s", sbcinfo->auto485 ? "yes" : "no");
> > +    pos += ts_addbuf(pos, "SRAM", "%s", sbcinfo->sram ? "yes" : "no");
> > +    pos += ts_addbuf(pos, "External Reset", "%s",
> > +             sbcinfo->external_reset ? "yes" : "no");
> 
> Most of these look like they should be simple "one value per file" sysfs
> files for your system.  That would make things much easier on your
> userspace tools to handle parsing them properly, right?
> 
> Why not do that instead?

I had a look at other drivers, and /sys/devices/platform/ts/ seems to be
a good place to hold those entries (one per options as you suggested).
Do you agree with that?

By the way, as they would be sysfs attributes, is Documentation/ABI the
best place to add the documentation file?

> 
> thanks,
> 
> greg k-h

Regards,
Vivien.
