Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1FBWdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 18:33:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401Ab1FBWdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 18:33:05 -0400
Subject: RE: [PATCH] TODO FLAG_POINTTOPOINT => FLAG_WWAN? usbnet/cdc_ncm:
 mark ncm devices as "mobile broadband devices" with FLAG_WWAN
From: Dan Williams <dcbw@redhat.com>
To: Alexey ORISHKO <alexey.orishko@stericsson.com>
Cc: Stefan Metzmacher <metze@samba.org>, Oliver Neukum <oliver@neukum.name>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 02 Jun 2011 17:35:31 -0500
In-Reply-To: <1307053743.21633.22.camel@dcbw.foobar.com>
References: <1306922913-17803-1-git-send-email-metze@samba.org>
	 <1306922913-17803-2-git-send-email-metze@samba.org>
	 <2AC7D4AD8BA1C640B4C60C61C8E520153E3C07E583@EXDCVYMBSTM006.EQ1STM.local>
	 <1307053743.21633.22.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1307054132.21633.25.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-02 at 17:29 -0500, Dan Williams wrote:
> On Wed, 2011-06-01 at 12:20 +0200, Alexey ORISHKO wrote:
> > > -----Original Message-----
> > > From: netdev-owner@vger.kernel.org [mailto:netdev-
> > > owner@vger.kernel.org] On Behalf Of Stefan Metzmacher
> > > Sent: Wednesday, June 01, 2011 12:09 PM
> > 
> > 
> > > -	.flags = FLAG_POINTTOPOINT | FLAG_NO_SETINT | FLAG_MULTI_PACKET,
> > > +	.flags = FLAG_WWAN | FLAG_NO_SETINT | FLAG_MULTI_PACKET,
> > 
> > This patch will introduce incompatibility with already existing
> > applications, which track usbX devices. As a result, end user
> > application will stop working.
> 
> Applications should *never* track devices based solely on a device name
> prefix.  What do they do when the device gets renamed either by udev
> rules or the user?  It's simply broken.  Device names are not stable API
> and they can and do change at will.  Applications that expect them to
> have a stable prefix are simply broken.

A follow-on to this is that if you really care about specific devices,
your application can use udev rules to "tag" specific interfaces based
on USB VID/PID/GUID or other device attributes, and check for those tags
in your program.  Use udev (good) or netlink (good) or SIOCGIFCONF (bad)
to enumerate the various network interfaces on the system and pick the
one you want using the udev tags instead of hardcoding stuff that will
inevitably break, as you've seen here.  Yeah, it's more code.  But hey,
it doesn't break when people do something you don't expect!

Dan


