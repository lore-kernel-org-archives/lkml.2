Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab1FCTWL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 15:22:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753620Ab1FCTWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 15:22:09 -0400
Subject: RE: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
From: Dan Williams <dcbw@redhat.com>
To: Alexey ORISHKO <alexey.orishko@stericsson.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        Stefan Metzmacher <metze@samba.org>,
        Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 03 Jun 2011 14:24:34 -0500
In-Reply-To: <2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B5F2@EXDCVYMBSTM006.EQ1STM.local>
References: <1306922913-17803-1-git-send-email-metze@samba.org>
	 <1306922913-17803-2-git-send-email-metze@samba.org>
	 <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E583@EXDCVYMBSTM006.EQ1STM.local>
	 <1307053743.21633.22.camel@dcbw.foobar.com>
	 <1307054132.21633.25.camel@dcbw.foobar.com>
	 <5203.1307062683@turing-police.cc.vt.edu>
	 <2AC7D4AD8BA1C640B4C60C61C8E520153E3C13B5F2@EXDCVYMBSTM006.EQ1STM.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1307129076.23945.21.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-06-03 at 11:45 +0200, Alexey ORISHKO wrote:
> > -----Original Message-----
> > From: Valdis.Kletnieks@vt.edu [mailto:Valdis.Kletnieks@vt.edu]
> > Sent: Friday, June 03, 2011 2:58 AM
> > 
> > > A follow-on to this is that if you really care about specific
> > devices,
> > > your application can use udev rules to "tag" specific interfaces
> > based
> > > on USB VID/PID/GUID or other device attributes, and check for those
> > > tags in your program.  Use udev (good) or netlink (good) or
> > > SIOCGIFCONF (bad) to enumerate the various network interfaces on the
> > > system and pick the
> > 
> > I think Alexey's point was that the patch will hose up programs that
> > currently do the netlink or  SIOCGIFCONF thing and look for
> > FLAG_POINTTOPOINT.
> 
> Just to clarify, I was objecting to renaming interface name mostly because
> devices which use CDC NCM function might be something different from wwan
> devices. I would prefer to keep a generic name of interface (usbX or ethX).
> 
> As an option anyone can use udev rules to set interface name they want 
> for their device based on VID/PID or MAC address or something else.
> I've already provided udev rule example earlier in this thread.
> 
> Dan, is it in line with your statement?

Sort of; the point of 'wwan' is to detect when we need some auxiliary
configuration to make the net interface actually do something.  It
allows userspace tools (like NetworkManager) to treat ethernet
interfaces that do require aux config specially.  Matching driver name
is not the solution here since as you said the driver can drive a wide
variety of hardware not all of which may be WWAN.

But there are a bunch of devices we *know* are 3G devices, and for those
we should mark them as WWAN.  And the best place to do that is in the
driver where that device's USB IDs and/or workarounds may exist, just
like the existing cdc-wdm stuff for Ericsson MBM minicards.  This
ensures that we keep this information in *one* place, instead of
sprinkling pieces around between userspace udev rules, apps, and the
driver.

Dan


