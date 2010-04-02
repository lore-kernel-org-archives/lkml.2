Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab0DBSfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:35:30 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:53091 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab0DBSfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:35:15 -0400
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
From: Ben Hutchings <bhutchings@solarflare.com>
To: "\"L. Alberto" =?ISO-8859-1?Q?Gim=E9nez=22?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, oliver@neukum.org, linville@tuxdriver.com,
       j.dumon@option.com, steve.glendinning@smsc.com, davem@davemloft.net,
       gregkh@suse.de, dgiagio@gmail.com, Daniel Borca <dborca@yahoo.com>
In-Reply-To: <4BB62F33.1020507@sysvalve.es>
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>
	 <1270064527-8485-1-git-send-email-agimenez@sysvalve.es>
	 <1270077538.8653.484.camel@localhost>  <4BB62620.3070807@sysvalve.es>
	 <1270228883.12516.140.camel@localhost>  <4BB62F33.1020507@sysvalve.es>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 02 Apr 2010 19:35:08 +0100
Message-ID: <1270233308.12516.145.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Apr 2010 18:35:41.0816 (UTC) FILETIME=[4C73BF80:01CAD293]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17294.005
X-TM-AS-Result: No--27.636400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 19:53 +0200, "L. Alberto Giménez" wrote:
> On 04/02/2010 07:21 PM, Ben Hutchings wrote:
> > On Fri, 2010-04-02 at 19:15 +0200, "L. Alberto Giménez" wrote:
> >> On 04/01/2010 01:18 AM, Ben Hutchings wrote:
> >>> On Wed, 2010-03-31 at 21:42 +0200, L. Alberto Giménez wrote:
> >>> [...]
> >>>> --- /dev/null
> >>>> +++ b/drivers/net/usb/ipheth.c
> >>> [...]
> >>>> +	usb_fill_bulk_urb(dev->tx_urb, udev,
> >>>> +			  usb_sndbulkpipe(udev, dev->bulk_out),
> >>>> +			  dev->tx_buf, IPHETH_BUF_SIZE,
> >>>> +			  ipheth_sndbulk_callback,
> >>>> +			  dev);
> >>>> +	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> >>>> +
> >>>> +	retval = usb_submit_urb(dev->tx_urb, GFP_ATOMIC);
> >>>> +	if (retval) {
> >>>> +		err("%s: usb_submit_urb: %d", __func__, retval);
> >>>> +		dev->stats.tx_errors++;
> >>>> +		dev_kfree_skb_irq(skb);
> >>>> +	} else {
> >>>> +		net->trans_start = jiffies;
> >>> No longer needed.
> >> What is not longer needed? The assignment, the whole "else" branch? If
> >> the assignment is what is not needed, can I just remove that line, right?
> > 
> > The assignment is not needed.
> 
> Hi,
> 
> I've been looking into this and it seems that the net_device.trans_start
> field is now deprecated in favor of net_device.rx_queue.trans_start
[...]

The networking core updates netdev_queue::trans_start by calling
txq_trans_update() where necessary.  Drivers should not touch either
net_device::trans_start or netdev_queue::trans_start any more.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

