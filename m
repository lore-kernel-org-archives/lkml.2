Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2HSKYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 06:24:03 -0400
Received: from canardo.mork.no ([148.122.252.1]:49554 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287Ab2HSKYB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 06:24:01 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Fengguang Wu <fengguang.wu@intel.com>, Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb\@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan\, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Organization: m
References: <CACVXFVO0TYHP0=GZVo1cz_FdxXSbX-xQ8vwrwUrZ2Y0nj7yDzg@mail.gmail.com>
	<Pine.LNX.4.44L0.1208171031100.25520-100000@netrider.rowland.org>
	<20120817144253.GA12835@kroah.com>
	<CACVXFVMeUmLh=Tu3PHbgHQNX+c-z50_CoAkdJS_uCw=E3dO2dw@mail.gmail.com>
Date: Sun, 19 Aug 2012 12:23:38 +0200
In-Reply-To: <CACVXFVMeUmLh=Tu3PHbgHQNX+c-z50_CoAkdJS_uCw=E3dO2dw@mail.gmail.com>
	(Ming Lei's message of "Sat, 18 Aug 2012 08:58:39 +0800")
Message-ID: <87a9xrmb85.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ming Lei <tom.leiming@gmail.com> writes:
> On Fri, Aug 17, 2012 at 10:42 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Fri, Aug 17, 2012 at 10:38:16AM -0400, Alan Stern wrote:
>>> On Fri, 17 Aug 2012, Ming Lei wrote:
>>>
>>> > But,  if HOTPLUG is not enabled, should device_add() trigger driver probe
>>> > further after kernel init is completed?  Or even devices should be allowed
>>> > to add into system?
>>>
>>> Indeed, does it make any sense to have USB support at all if HOTPLUG
>>> isn't enabled?  Should USB select HOTPLUG?
>>
>> Well, a long time ago people wanted to use USB but not have HOTPLUG
>> enabled in their systems for various (odd) embedded systems.  As it's
>> pretty hard to even turn off HOTPLUG these days, I'd be more likely to
>> just remove CONFIG_HOTPLUG entirely given the dynamic nature of almost
>> all systems.
>
> It should make sense, otherwise all device id table should not use
> __devinit* markings. There are lots of pci driver usage on it.

You might want to start here then:

/**
 * DEFINE_PCI_DEVICE_TABLE - macro used to describe a pci device table
 * @_table: device table name
 *
 * This macro is used to create a struct pci_device_id array (a device table)
 * in a generic manner.
 */
#define DEFINE_PCI_DEVICE_TABLE(_table) \
        const struct pci_device_id _table[] __devinitconst



Bjørn
