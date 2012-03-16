Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963Ab2CPQF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 12:05:28 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:60372 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2CPQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 12:05:26 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20323.25792.171143.809563@quad.stoffel.home>
Date: Fri, 16 Mar 2012 12:05:20 -0400
From: "John Stoffel" <john@stoffel.org>
To: simon@mungewell.org
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Building BarGraph with LED subsystem
In-Reply-To: <1b29a178dd288b0f17608b5815ca77a5.squirrel@mungewell.org>
References: <1b29a178dd288b0f17608b5815ca77a5.squirrel@mungewell.org>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


simon> I have a couple of questions about the (user-land) use of the
simon> LED subsystem.

simon> I recently offered a patch for controlling the LEDs of the G27 gaming
simon> wheel, on which the LEDs are arranged in a bar-graph of 5 to show
simon> simulation RPM. The suggestion was to use the LED subsystem, which this
simon> patch implements.

simon> http://www.spinics.net/lists/linux-input/msg19747.html

simon> Thinking further about how to about how to control this I was wondering
simon> whether a 'threshold' trigger would be useful. This would allow the use of
simon> value (uint?) to be compare against a threshold and the LED turned on/off
simon> automatically.

simon> The main benefit of doing this as a 'trigger' is that we could 'link' (or
simon> 'sync') multiple LEDs to use the same value input, thus making the
simon> user-land stuff trivial.

While making the kernel more complex... esp for a feature which is of
such limited use.  Do it all in userland, it's easier, you can use
floating point math, etc.  And to test changes, you don't have to
recompile a module and unload/reload it, etc.

Keeping as much of this in userland is better.

simon> Also I have a question about the default permissions on the LED
simon> controls; Is it possible to register LEDs so that users have
simon> write permission? At present the controls are only accessible
simon> as root.

udev is the answer here.  You probably want to make it so that the
LEDs are open to the user logged into the system console or currently
active Xsession.

John
