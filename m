Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab1CAVA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:00:57 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60392 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757226Ab1CAVA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:00:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=aSY7tcl22QmPuXdpyN13sCcQITzMorLm0XuAITAXLtkdVW6o9mRkIqpsC6mfdCGvrQ
         S5wSvVAjiiH1i3G3avpGWs/3yzcyFCtn/VGqxqadszi6E4irOgGkF2uJQgRwxvM+Ejnw
         twnLrf0Jd7YWYlbppSg/9SRRfl9repEdwt2Fk=
Date: Tue, 1 Mar 2011 23:00:50 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc6: SysRq broken?
Message-ID: <20110301210050.GA10977@p183.telecom.by>
References: <20110228214054.GA18538@p183.telecom.by>
 <201102281357.21747.dmitry.torokhov@gmail.com>
 <20110228220447.GB18538@p183.telecom.by>
 <20110301180429.GD27560@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110301180429.GD27560@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 10:04:29AM -0800, Dmitry Torokhov wrote:
> On Tue, Mar 01, 2011 at 12:04:47AM +0200, Alexey Dobriyan wrote:
> > On Mon, Feb 28, 2011 at 01:57:21PM -0800, Dmitry Torokhov wrote:
> > > On Monday, February 28, 2011 01:40:54 pm Alexey Dobriyan wrote:
> > > > It just strikes me that SysRq is broken here:
> > > > Alt+SysRq+h doesn't print anything
> > > > 
> > > > CONFIG_MAGIC_SYSRQ=y
> > > > CONFIG_INPUT_EVDEV=y
> > > > kernel.sysrq=1
> > > > echo h >/proc/sysrq-trigger works
> > > > 
> > > > Keyboard is USB one, "Logitech HID compliant keyboard".
> > > 
> > > What does /proc/bus/input/devices show?
> > 
> > 
> > I: Bus=0003 Vendor=046d Product=c30e Version=0110
> > N: Name="Logitech HID compliant keyboard"
> > P: Phys=usb-0000:00:1d.0-1.2/input0
> > S: Sysfs=/devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input3
> > U: Uniq=
> > H: Handlers=sysrq kbd event3 
> > B: PROP=0
> > B: EV=120013
> > B: KEY=1000000000007 ff800000000007ff febeffdff3cfffff fffffffffffffffe
> > B: MSC=10
> > B: LED=7
> > 
> 
> Hmm, looks like we bound sysrq handler here and the device has both alt
> and SysRq keys.

Yes, both.

> Is it only help that is not working? What abouth other functions (reboot, etc)?

Seems so, SysRq+Sync works, SysRq+L works as well.
