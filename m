Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab2HQKZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 06:25:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:50906 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2HQKZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 06:25:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,784,1336374000"; 
   d="scan'208";a="203425838"
Date: Fri, 17 Aug 2012 18:24:56 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "Lan, Tianyu" <tianyu.lan@intel.com>
Subject: Re: BUG: unable to handle kernel paging request in usb_match_id()
Message-ID: <20120817102456.GA31230@localhost>
References: <20120805025938.GA8954@localhost>
 <20120805165826.GB13913@kroah.com>
 <20120817020046.GA24406@localhost>
 <20120817034825.GC7770@kroah.com>
 <20120817054441.GA28434@localhost>
 <87wr0xnbnm.fsf@nemi.mork.no>
 <87sjblnaye.fsf@nemi.mork.no>
 <20120817092708.GA30371@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120817092708.GA30371@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 05:27:08PM +0800, Fengguang Wu wrote:
> Hi Bjørn,
> 
> > -static const struct usb_device_id id_table[] __devinitconst = {
> > +static const struct usb_device_id id_table[] = {
> 
> Good catch! It magically fixed the oops. So that id_table was
> freed sometime with __devinitconst?
> 
> There are some more "usb_device_id .* __devinitconst" users in the system,
> Shall they be fixed as well?

This should be a complete list:

definitions:
        static const struct usb_device_id smsusb_id_table[] __devinitconst = {
        static const __devinitdata struct usb_device_id device_table[] = {
        static const struct usb_device_id device_table[] __devinitconst = {
        static struct usb_device_id p54u_table[] __devinitdata = {
        static struct usb_device_id rtl8187_table[] __devinitdata = {
        static struct usb_device_id vt6656_table[] __devinitdata = {
        static const struct usb_device_id wb35_table[] __devinitconst = {
        static const struct usb_device_id id_table[] __devinitconst = {

files:
        drivers/media/video/gspca/jl2005bcd.c
        drivers/net/wireless/p54/p54usb.c
        drivers/net/wireless/rtl818x/rtl8187/dev.c
        drivers/usb/misc/emi62.c
        drivers/media/dvb/siano/smsusb.c
        drivers/media/video/gspca/spca506.c
        drivers/staging/winbond/wbusb.c
        drivers/staging/vt6656/main_usb.c

Thanks,
Fengguang
