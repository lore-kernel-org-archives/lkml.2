Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab1E2Gqw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 02:46:52 -0400
Received: from smtprelay05.ispgateway.de ([80.67.31.98]:58464 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1E2Gqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 02:46:51 -0400
From: Michael Bauer <michael@m-bauer.org>
To: linux-input@vger.kernel.org
Subject: Re: [PATCH] hid: Fix Logitech Driving Force Pro wheel
Date: Sun, 29 May 2011 08:46:59 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-logitech; KDE/4.6.3; x86_64; ; )
Cc: simon@mungewell.org, linux-kernel@vger.kernel.org,
        "Jiri Kosina" <jkosina@suse.cz>
References: <201105282037.22888.michael@m-bauer.org> <fd06492f61f15697eb1c8400e29ec7bd.squirrel@host171.canaca.com> <8942e3cdf4941912b0855e64939e5939.squirrel@host171.canaca.com>
In-Reply-To: <8942e3cdf4941912b0855e64939e5939.squirrel@host171.canaca.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105290846.59531.michael@m-bauer.org>
X-Df-Sender: michael@m-bauer.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

> > 2). The original does Y then 3 others, the replacement does Y + RZ then 1
> > other.
> 
> OK I missed that you had 'disabled' the first byte value after the hat
> switch (which is presumably the combined acc-brake), in preference for the
> seperate ACC and Brake.
> 
> Is there a reason to prevent the combined acc-brake being reported to the
> system?
> 
> Surely it would be best to report all options so that the app can decide
> which one to use.... I can see that you might want to relabel them for
> consistance with Windows.

Well, i thought about this also and normally i would agree with your 
statement. But my conclusion was to remove the combined axis. Looking at 
Windows all wheel controllers i saw so far have a setting in their driver to 
enable or disable the separate axis. But i never saw a controller which 
provided both separate and combined at the same time. 
I am pretty sure there will be trouble when assigning these controls within an 
application. 
Often the control assignement works like this: User clicks "set axis for 
acceleration", application asks "please move the desired axis" and then 
automatically choses the "moving" axis.
If we report both combined and separate at the same time, the application will 
have a hard time deciding which one to use, as they both will change their 
values.
 
> Do you know what the 4th (and last) byte value is?
> Simon

No idea - But I never observed any change being reported on this byte, so at 
the moment i assume it is completely unused.
 
Best regards
Michael
