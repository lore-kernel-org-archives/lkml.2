Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761852Ab2CPQ51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:57:27 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:60928 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423078Ab2CPQ5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:57:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20323.28910.434931.307759@quad.stoffel.home>
Date: Fri, 16 Mar 2012 12:57:18 -0400
From: "John Stoffel" <john@stoffel.org>
To: simon@mungewell.org
Cc: "John Stoffel" <john@stoffel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Building BarGraph with LED subsystem
In-Reply-To: <8107d8a0e50b64dd45dc749da87b2c7b.squirrel@mungewell.org>
References: <1b29a178dd288b0f17608b5815ca77a5.squirrel@mungewell.org>
	<20323.25792.171143.809563@quad.stoffel.home>
	<8107d8a0e50b64dd45dc749da87b2c7b.squirrel@mungewell.org>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "simon" == simon  <simon@mungewell.org> writes:

simon> Also I have a question about the default permissions on the LED
simon> controls; Is it possible to register LEDs so that users have
simon> write permission? At present the controls are only accessible
simon> as root.
>> 
>> udev is the answer here.  You probably want to make it so that the
>> LEDs are open to the user logged into the system console or currently
>> active Xsession.

simon> So what would be the best way to achieve this (once the code
simon> gets into kernel)? I mean so that 'Jane Doe' get the LEDs
simon> working when she plugs in her wheel...

Well, if you have an application that wants to control the wheel LEDs,
then it needs to plug in an discover whether the wheel exists, whether
it's got LEDs, etc.  All part of the HID subsystem as understand it. 

simon> At present the patch uses the devices ID's to register the LED's. ie.
simon> --

simon> Mar 14 14:57:35 ubuntu kernel: [ 6462.204185] Registered led device:
simon> 0003:046D:C294.0009::RPM1
simon> Mar 14 14:57:35 ubuntu kernel: [ 6462.204251] Registered led device:
simon> 0003:046D:C294.0009::RPM2
simon> Mar 14 14:57:35 ubuntu kernel: [ 6462.204301] Registered led device:
simon> 0003:046D:C294.0009::RPM3
simon> Mar 14 14:57:35 ubuntu kernel: [ 6462.204354] Registered led device:
simon> 0003:046D:C294.0009::RPM4
simon> Mar 14 14:57:35 ubuntu kernel: [ 6462.204402] Registered led device:
simon> 0003:046D:C294.0009::RPM5
simon> --

This part is probably fine, but I'd call it 'LED1..5' instead, since
they're LEDs, not true RPM indicators.  I guess what I'm trying to say
is that putting as much of this into user space, makes for a much more
flexible environment.

You might want to look into the Linux HID sub-system for how it
enumerates the abilities of devices like keyboards, game pads, etc.
They already have alot of that infrastructure in place. 

John

