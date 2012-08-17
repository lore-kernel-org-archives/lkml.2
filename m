Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946Ab2HQMQZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 08:16:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39391 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab2HQMQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 08:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120817102456.GA31230@localhost>
References: <20120805025938.GA8954@localhost>
	<20120805165826.GB13913@kroah.com>
	<20120817020046.GA24406@localhost>
	<20120817034825.GC7770@kroah.com>
	<20120817054441.GA28434@localhost>
	<87wr0xnbnm.fsf@nemi.mork.no>
	<87sjblnaye.fsf@nemi.mork.no>
	<20120817092708.GA30371@localhost>
	<20120817102456.GA31230@localhost>
Date: Fri, 17 Aug 2012 20:16:15 +0800
Message-ID: <CACVXFVO0TYHP0=GZVo1cz_FdxXSbX-xQ8vwrwUrZ2Y0nj7yDzg@mail.gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
From: Ming Lei <tom.leiming@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 6:24 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> On Fri, Aug 17, 2012 at 05:27:08PM +0800, Fengguang Wu wrote:
>> Hi Bjørn,
>>
>> > -static const struct usb_device_id id_table[] __devinitconst = {
>> > +static const struct usb_device_id id_table[] = {
>>
>> Good catch! It magically fixed the oops. So that id_table was
>> freed sometime with __devinitconst?
>>
>> There are some more "usb_device_id .* __devinitconst" users in the system,
>> Shall they be fixed as well?

The issue should be triggered only when HOTPLUG is not set.

But,  if HOTPLUG is not enabled, should device_add() trigger driver probe
further after kernel init is completed?  Or even devices should be allowed
to add into system?



Thanks,
-- 
Ming Lei
