Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751326Ab1FHQSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 12:18:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53942 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001Ab1FHQS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 12:18:29 -0400
X-Sasl-enc: fLSd7toXdTH8weKt2/glAcmECptztfjC1To91NCcomhN 1307549907
Date: Wed, 8 Jun 2011 09:09:31 -0700
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Kulikov Vasiliy <segooon@gmail.com>, Endre Kollar <taxy443@gmail.com>,
        Arjan Mels <arjan.mels@gmx.net>, Ilia Mirkin <imirkin@alum.mit.edu>,
        David Chang <dchang@novell.com>,
        Himanshu Chauhan <hschauhan@nulltrace.org>,
        Max Vozeler <max@vozeler.com>, Arnd Bergmann <arnd@arndb.de>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usbip: handle length at sysfs show() functions
Message-ID: <20110608160931.GB21645@kroah.com>
References: <4DE5CA9F.6010303@freemail.hu>
 <20110607213418.GB11102@kroah.com>
 <4DEF0822.7070500@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DEF0822.7070500@freemail.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 07:26:58AM +0200, Németh Márton wrote:
> Greg KH wrote:
> > On Wed, Jun 01, 2011 at 07:14:07AM +0200, Németh Márton wrote:
> >> The sysfs show() functions shall return the actual content length of
> >> the result buffer. According to Documentation/filesystems/sysfs.txt:215
> >> the scnprintf() function is preferred.
> >>
> >> See also the article titled "snprintf() confusion" at
> >> http://lwn.net/Articles/69419/ .
> >
> > [...]
> >
> > Here we are doing lots of work to try to put more than one value in the
> > sysfs file, and return the proper data to the kernel about how big the
> > buffer we used.
> > 
> > That's wrong, and violates the "one value per file" sysfs rule, so that
> > should be fixed instead of trying to change the sprintf() call.
> 
> As I understand there is a need to change the design here. Currently I
> get the following content when vhci-hcd is loaded but not yet used:
> 
> $ cat /sys/devices/platform/vhci_hcd/status
> prt sta spd bus dev socket           local_busid
> 000 004 000 000 000 0000000000000000 0-0
> 001 004 000 000 000 0000000000000000 0-0
> 002 004 000 000 000 0000000000000000 0-0
> 003 004 000 000 000 0000000000000000 0-0
> 004 004 000 000 000 0000000000000000 0-0
> 005 004 000 000 000 0000000000000000 0-0
> 006 004 000 000 000 0000000000000000 0-0
> 007 004 000 000 000 0000000000000000 0-0
> 
> The fields are: port, status, speed, device ID, socket pointer and
> local busid name. This is too complex for sysfs. Maybe we could extend
> the devices file of usbfs with some new rows?

Ick, I doubt it as there are lots of tools that parse that file already.

But yes, you are correct, this should not be in sysfs at all.

What's the use for this file?  Who uses it?  Is it just debugging
output?  Information for people to gaze at if they feel like it?
Something else?

Once we figure that out, then we can determine where it should go
(debugfs, sysfs in a different file format, usbfs, etc.)

thanks,

greg k-h
