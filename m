Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab2AHArN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jan 2012 19:47:13 -0500
Received: from imr4.ericy.com ([198.24.6.9]:43904 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab2AHArM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jan 2012 19:47:12 -0500
Date: Sat, 7 Jan 2012 16:45:02 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Arnaud Patard <arnaud.patard@rtp-net.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Roman Mamedov <rm@romanrm.ru>, Manuel Roeder <manuel_roeder@gmx.de>,
        Michael Ott <michael@king-coder.de>,
        Rodolfo Giometti <giometti@linux.it>,
        Mauro Barella <mbarella@vds-it.com>
Subject: Re: [2.6.37 -> 2.6.38 regression] "mv64xxx: I2C bus locked, block:
 1, time_left: 0" every few seconds
Message-ID: <20120108004502.GA20549@ericsson.com>
References: <20120101042401.4bef017e@natsu>
 <20120101073255.GA2402@elie.hsd1.il.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120101073255.GA2402@elie.hsd1.il.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 01, 2012 at 01:32:55AM -0600, Jonathan Nieder wrote:
> Hi,
> 
> Roman Mamedov wrote[1]:
> 
> > This bug is still present for me in the latest kernel version in
> > Debian testing (3.1.6).
> >
> > The last properly working kernel version seems to be:
> [...]
> > And the problem occurs since:
> [...]
> 
> Thanks.  Arnaud, any hints?  To summarize:
> 
>  - Michael Ott reported with Debian kernel 2.6.38-3 (which is closely
>    based on stable v2.6.38.2):
> 
> 	syslog tell me every few seconds:
> 	i2c i2c-0: mv64xxx: I2C bus locked, block: 1, time_left: 0
> 
>  - Manuel Roeder reported the same and found that upstream v2.6.38
>    triggers the problem and v2.6.37.6 does not.
> 
>  - Roman Mamedov finds the bug present in Debian 3.1.6-1 (which
>    is closely based on stable v3.1.6) and Debian 2.6.37-2 (based on
>    stable v2.6.37.2) but not Debian 2.6.37-1 (based on mainline
>    v2.6.37).
> 
> The regression range described above seems a little inconsistent to
> me, so maybe there's something more going on.
> 
Points to commit eda6bee6c7e67b5bd17bdbced0926f5687f686d5 (i2c-mv64xxx: send repeated START
between messages in xfer). Maybe you can back it out and see if it makes a difference.

Guenter
