Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0J3OLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 10:11:31 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:42438 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753945Ab0J3OL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 10:11:27 -0400
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Oct 2010 10:11:27 EDT
X-Sasl-enc: mFow5z+i1BTMfbm80rrFPEURWo+Cl6attUOvrpGmWdD4 1288447250
Date: Sat, 30 Oct 2010 12:00:47 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, samu.p.onkalo@nokia.com,
        alan@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: sysfs and power management
Message-ID: <20101030140047.GA24464@khazad-dum.debian.net>
References: <1288177143.12206.22.camel@4fid08082>
 <20101027124816.7087436a@linux.intel.com>
 <62697B07E9803846BC582181BD6FB6B836EB2994F4@NOK-EUMSG-02.mgdnok.nokia.com>
 <20101027152809.39701917@lxorguk.ukuu.org.uk>
 <20101029195039.GA26401@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029195039.GA26401@suse.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010, Greg KH wrote:
> back to sleep.  That's probably the best way to do this, as userspace
> isn't going to open the sysfs file and not close it instantly anyway
> after it has read the data (seeking on a sysfs file isn't really
> recommended, even if it sometimes seems to work.)

Well, it is documented that seek(start of file) on sysfs works, and it
is ABI already (some userspace uses it on poll/select-capable
attributes).  So, maybe seek(somewhere that is not the start of the
file) doesn't work -- and it should return an error in that case if it
doesn't already...  but it is a lot more deterministic than "sometimes"
;-)

So yes, userspace will open() and not close() a sysfs attribute immediately
afterwards.  It is not only shell crap that interfaces to the kernel over
sysfs :-)

It would make a lot of sense to support the poll/select model on any
sensor for which you have event-driven notifications of change from the
hardware or firmware.

I don't know about open/close notifications, however.  Usually you need
those when you're going to stream something to userspace, and there are FAR
better interfaces to use in that case, such as the ring buffers used by the
data acquisition devices, netlink (which userspace programmers seems not to
like much :p), input devices, and generic character devices...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
