Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2HRA6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 20:58:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:49786 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab2HRA6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 20:58:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120817144253.GA12835@kroah.com>
References: <CACVXFVO0TYHP0=GZVo1cz_FdxXSbX-xQ8vwrwUrZ2Y0nj7yDzg@mail.gmail.com>
	<Pine.LNX.4.44L0.1208171031100.25520-100000@netrider.rowland.org>
	<20120817144253.GA12835@kroah.com>
Date: Sat, 18 Aug 2012 08:58:39 +0800
Message-ID: <CACVXFVMeUmLh=Tu3PHbgHQNX+c-z50_CoAkdJS_uCw=E3dO2dw@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
From: Ming Lei <tom.leiming@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Fengguang Wu <fengguang.wu@intel.com>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 10:42 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Fri, Aug 17, 2012 at 10:38:16AM -0400, Alan Stern wrote:
>> On Fri, 17 Aug 2012, Ming Lei wrote:
>>
>> > But,  if HOTPLUG is not enabled, should device_add() trigger driver probe
>> > further after kernel init is completed?  Or even devices should be allowed
>> > to add into system?
>>
>> Indeed, does it make any sense to have USB support at all if HOTPLUG
>> isn't enabled?  Should USB select HOTPLUG?
>
> Well, a long time ago people wanted to use USB but not have HOTPLUG
> enabled in their systems for various (odd) embedded systems.  As it's
> pretty hard to even turn off HOTPLUG these days, I'd be more likely to
> just remove CONFIG_HOTPLUG entirely given the dynamic nature of almost
> all systems.

It should make sense, otherwise all device id table should not use
__devinit* markings. There are lots of pci driver usage on it.


Thanks,
-- 
Ming Lei
