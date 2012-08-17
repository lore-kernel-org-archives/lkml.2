Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab2HQNqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 09:46:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55898 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab2HQNqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 09:46:00 -0400
Date: Fri, 17 Aug 2012 06:45:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Message-ID: <20120817134554.GC2124@kroah.com>
References: <20120805025938.GA8954@localhost>
 <20120805165826.GB13913@kroah.com>
 <20120817020046.GA24406@localhost>
 <20120817034825.GC7770@kroah.com>
 <20120817054441.GA28434@localhost>
 <87wr0xnbnm.fsf@nemi.mork.no>
 <87sjblnaye.fsf@nemi.mork.no>
 <20120817092708.GA30371@localhost>
 <20120817102456.GA31230@localhost>
 <CACVXFVO0TYHP0=GZVo1cz_FdxXSbX-xQ8vwrwUrZ2Y0nj7yDzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVO0TYHP0=GZVo1cz_FdxXSbX-xQ8vwrwUrZ2Y0nj7yDzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 08:16:15PM +0800, Ming Lei wrote:
> On Fri, Aug 17, 2012 at 6:24 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > On Fri, Aug 17, 2012 at 05:27:08PM +0800, Fengguang Wu wrote:
> >> Hi Bjørn,
> >>
> >> > -static const struct usb_device_id id_table[] __devinitconst = {
> >> > +static const struct usb_device_id id_table[] = {
> >>
> >> Good catch! It magically fixed the oops. So that id_table was
> >> freed sometime with __devinitconst?
> >>
> >> There are some more "usb_device_id .* __devinitconst" users in the system,
> >> Shall they be fixed as well?
> 
> The issue should be triggered only when HOTPLUG is not set.
> 
> But,  if HOTPLUG is not enabled, should device_add() trigger driver probe
> further after kernel init is completed?  Or even devices should be allowed
> to add into system?

Yes, it can, and should, because you can add them through sysfs.

I'll go fix these up, I really hate the __devinit* markings, they really
are pointless these days, and only cause problems :(

Thanks all for tracking this down.

greg k-h
