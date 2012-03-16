Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422892Ab2CPPYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:24:50 -0400
Received: from host171.canaca.com ([67.55.55.225]:60104 "EHLO
	host171.canaca.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032852Ab2CPPYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:24:48 -0400
Message-ID: <1b29a178dd288b0f17608b5815ca77a5.squirrel@mungewell.org>
Date: Fri, 16 Mar 2012 11:24:47 -0400
Subject: Building BarGraph with LED subsystem
From: simon@mungewell.org
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.21
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - host171.canaca.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - mungewell.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
I have a couple of questions about the (user-land) use of the LED subsystem.

I recently offered a patch for controlling the LEDs of the G27 gaming
wheel, on which the LEDs are arranged in a bar-graph of 5 to show
simulation RPM. The suggestion was to use the LED subsystem, which this
patch implements.

http://www.spinics.net/lists/linux-input/msg19747.html

Thinking further about how to about how to control this I was wondering
whether a 'threshold' trigger would be useful. This would allow the use of
value (uint?) to be compare against a threshold and the LED turned on/off
automatically.

The main benefit of doing this as a 'trigger' is that we could 'link' (or
'sync') multiple LEDs to use the same value input, thus making the
user-land stuff trivial.

Concept - ledtrig-thres would provide the controls:
   threshold - value to compare against.
   value - incoming value, if >= threshold LED is lit, if < threshold LED
is dark.
   link - 'none' (standalone comparison), or the path to the value of
another LED's value to use (ie '/sys/leds/my_device::2/value')

Comments? Is this all too complex?


Also I have a question about the default permissions on the LED controls;
Is it possible to register LEDs so that users have write permission? At
present the controls are only accessible as root.

Many thanks,
Simon.


