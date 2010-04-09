Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab0DISLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 14:11:15 -0400
Received: from bamako.nerim.net ([62.4.17.28]:49592 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab0DISLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 14:11:14 -0400
Date: Fri, 9 Apr 2010 20:11:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: =?UTF-8?B?w4lyaWM=?= Piel <eric.piel@tremplin-utc.net>,
       Marcin Derlukiewicz <marcin@derlukiewicz.pl>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [lm-sensors] [PATCH] lis3lv02d: provide means to disable polled
  input interface
Message-ID: <20100409201110.5d75a24e@hyperion.delvare>
In-Reply-To: <alpine.LNX.2.00.1004091532150.8345@pobox.suse.cz>
References: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz>
	<4BBF2BD1.5050107@tremplin-utc.net>
	<alpine.LNX.2.00.1004091532150.8345@pobox.suse.cz>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010 15:32:59 +0200 (CEST), Jiri Kosina wrote:
> On Fri, 9 Apr 2010, Éric Piel wrote:
> 
> > > This is reported to create 20% CPU usage increase (and proportionaly higher
> > > power consumption) just for the ipolldevd kernel thread (which is used
> > > to read the sensor).
> > > 
> > > As most users probably only use the freefall functionality of the driver
> > > and not the joystick interface, provide means for disabling the registration
> > > of joystick device altogether via module parameter.
> > > (I'd rather make it default to 0, but this will break backwards compatibility).
> > Are you saying there is a 20% CPU usage even when the joystick interface
> > is not open? This should not happen (and this is not happening on my
> > laptop). The polling should happen only when a userspace app opens the
> > joystick interface (like running neverball).
> > 
> > So I'd tend to think it's more due to a misconfiguration of the system
> > (like xserver using the joystick interface as a pointer device) or it's
> > a bug in the way we set up the polling. Could you investigate and let me
> > know?
> 
> Marcin originally reported this to me.
> 
> Marcin, could you please check 'lsof' output to see whether the joystick 
> interface has been open by some application?

I would randomly blame hal. It keeps my IR remote control device opened
all the time and I have no idea why.

-- 
Jean Delvare
