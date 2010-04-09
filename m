Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0DINdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:33:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444Ab0DINdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:33:01 -0400
Date: Fri, 9 Apr 2010 15:32:59 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>, Pavel Machek <pavel@ucw.cz>,
       lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
       Marcin Derlukiewicz <marcin@derlukiewicz.pl>
Subject: Re: [PATCH] lis3lv02d: provide means to disable polled input
 interface
In-Reply-To: <4BBF2BD1.5050107@tremplin-utc.net>
Message-ID: <alpine.LNX.2.00.1004091532150.8345@pobox.suse.cz>
References: <alpine.LNX.2.00.1004091453530.8345@pobox.suse.cz> <4BBF2BD1.5050107@tremplin-utc.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Apr 2010, Éric Piel wrote:

> > This is reported to create 20% CPU usage increase (and proportionaly higher
> > power consumption) just for the ipolldevd kernel thread (which is used
> > to read the sensor).
> > 
> > As most users probably only use the freefall functionality of the driver
> > and not the joystick interface, provide means for disabling the registration
> > of joystick device altogether via module parameter.
> > (I'd rather make it default to 0, but this will break backwards compatibility).
> Are you saying there is a 20% CPU usage even when the joystick interface
> is not open? This should not happen (and this is not happening on my
> laptop). The polling should happen only when a userspace app opens the
> joystick interface (like running neverball).
> 
> So I'd tend to think it's more due to a misconfiguration of the system
> (like xserver using the joystick interface as a pointer device) or it's
> a bug in the way we set up the polling. Could you investigate and let me
> know?

Marcin originally reported this to me.

Marcin, could you please check 'lsof' output to see whether the joystick 
interface has been open by some application?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
