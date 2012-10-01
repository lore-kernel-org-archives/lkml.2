Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab2JADY5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 23:24:57 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:46313 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751564Ab2JADY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 23:24:56 -0400
Message-ID: <50690CFE.6010600@xenotime.net>
Date: Sun, 30 Sep 2012 20:24:46 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Tim Shepard <shep@alum.mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_EXPERT is a booby trap
References: <E1TIVdh-0007iT-00@www.xplot.org>
In-Reply-To: <E1TIVdh-0007iT-00@www.xplot.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2012 07:21 PM, Tim Shepard wrote:

> A month or two ago when I attempted to upgrade from 3.4 to 3.5 on my
> MacBook Pro laptop, in preparation to try an interesting patch to TCP
> developed against 3.5 by a colleague, my keyboard stopped working.  I
> tried bisecting, but that lead to nowhere useful and much confusion.
> 
> 
> It turns out that while I was looking for some debug options under
> "General setup" and "Kernel hacking", I turned on "Configure standard
> kernel features (expert users)" which is also known as CONFIG_EXPERT.
> I read the documentation for that option, and I perused the options
> which appeared underneath when it was turned on, thought to myself "oh,
> hmm, I don't want to change any of these" and wandered off and
> eventually found what I was actually looking for elsewhere in the
> kernel configuration tree.
> 
> This weekend I finally figured out why the keyboard in my MacBook Pro
> stopped working between 3.4 and 3.5.
> 
> When I turned on CONFIG_EXPERT it turned off CONFIG_HID_APPLE.  There
> was no warning that selecting "Configure standard kernel features" will
> invisibly turn off needed things elsewhere in the configuration tree.
> 
> Something needs to be fixed, but it's not obvious that any simple change
> will work without causing other troubles.
> 
> I've read some of the lkml history history and learned that references
> to CONFIG_EXPERT (like the one on CONFIG_HID_APPLE) used to be
> references to CONFIG_EMBEDDED, so CONFIG_EXPERT used to mean something
> else.
> 
> Maybe "make menuconfig" should show you all the things that you've just
> changed and ask for confirmation when changing one configuration option
> causes actual configuration changes elsewhere in the tree.
> 
> And may I suggest that CONFIG_EXPERT should be factored into two
> CONFIGs, one of which makes configuration things visible, and another
> which changes the default values to something more appropriate for
> embedded systems (perhaps call it CONFIG_EMBEDDED_DEFAULTS).  That way
> you'd have to select CONFIG_EXPERT, and then select the
> CONFIG_EMBEDDED_DEFAULTS option that CONFIG_EXPERT made visible to
> actually change any configuration, and the documentation for
> CONFIG_EMBEDDED_DEFAULTS could explain that it changes defaults
> throughout the tree (and selecting CONFIG_EXPERT alone would not go off
> and muck things up with no warning).
> 
> The transition plan such a factoring needs some further thought to avoid
> breaking anyone's current configuration when they "make oldconfig".


I don't disagree with you that it can be a problem, but
the help text for CONFIG_EXPERT does say:

	Only use this if you really know what you are doing.


Anyway, the hid drivers are certainly a big user of this mechanism.
Many of them are like HID_APPLE:

config HID_APPLE
	tristate "Apple {i,Power,Mac}Books" if EXPERT
	depends on (USB_HID || BT_HIDP)
	default !EXPERT


-- 
~Randy
