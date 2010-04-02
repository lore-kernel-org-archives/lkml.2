Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab0DBRVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:21:39 -0400
Received: from mail.solarflare.com ([216.237.3.220]:48591 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab0DBRVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:21:32 -0400
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
From: Ben Hutchings <bhutchings@solarflare.com>
To: "\"L. Alberto" =?ISO-8859-1?Q?Gim=E9nez=22?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, oliver@neukum.org, linville@tuxdriver.com,
       j.dumon@option.com, steve.glendinning@smsc.com, davem@davemloft.net,
       gregkh@suse.de, dgiagio@gmail.com, dborca@yahoo.com
In-Reply-To: <4BB62620.3070807@sysvalve.es>
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>
	 <1270064527-8485-1-git-send-email-agimenez@sysvalve.es>
	 <1270077538.8653.484.camel@localhost>  <4BB62620.3070807@sysvalve.es>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Fri, 02 Apr 2010 18:21:23 +0100
Message-ID: <1270228883.12516.140.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Apr 2010 17:21:58.0552 (UTC) FILETIME=[FFFB3980:01CAD288]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17294.005
X-TM-AS-Result: No--33.107800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-02 at 19:15 +0200, "L. Alberto Giménez" wrote:
> On 04/01/2010 01:18 AM, Ben Hutchings wrote:
> > On Wed, 2010-03-31 at 21:42 +0200, L. Alberto Giménez wrote:
> > [...]
> >> --- /dev/null
> >> +++ b/drivers/net/usb/ipheth.c
> > [...]
> 
> Hi Ben,
> 
> Upstream has fixed several errors pointed out by you and Oliver (thanks
> for that), but some of them are still pending.
> 
> I will send patches on top of my last driver submission (if the proper
> way would be resubmit the whole code, please tell me. Anyway I need to
> clarify some doubts...

Since David Miller has not merged your original patch, you should send a
single new patch with the changes incorporated.

> >> +	usb_fill_bulk_urb(dev->tx_urb, udev,
> >> +			  usb_sndbulkpipe(udev, dev->bulk_out),
> >> +			  dev->tx_buf, IPHETH_BUF_SIZE,
> >> +			  ipheth_sndbulk_callback,
> >> +			  dev);
> >> +	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> >> +
> >> +	retval = usb_submit_urb(dev->tx_urb, GFP_ATOMIC);
> >> +	if (retval) {
> >> +		err("%s: usb_submit_urb: %d", __func__, retval);
> >> +		dev->stats.tx_errors++;
> >> +		dev_kfree_skb_irq(skb);
> >> +	} else {
> >> +		net->trans_start = jiffies;
> > 
> > No longer needed.
> 
> What is not longer needed? The assignment, the whole "else" branch? If
> the assignment is what is not needed, can I just remove that line, right?

The assignment is not needed.

> > [...]
> >> +#ifdef HAVE_NET_DEVICE_OPS
> >> +static const struct net_device_ops ipheth_netdev_ops = {
> >> +       .ndo_open = &ipheth_open,
> >> +       .ndo_stop = &ipheth_close,
> >> +       .ndo_start_xmit = &ipheth_tx,
> >> +       .ndo_tx_timeout = &ipheth_tx_timeout,
> >> +       .ndo_get_stats = &ipheth_stats,
> >> +};
> >> +#endif
> > 
> > Remove the #ifdef, there is no question whether we have net_device_ops.
> 
> Ok, I will just remove both #ifdefs, but why is that? Maybe in previous
> versions of the kernel the net_device_ops struct was introduced and now
> it's present no matter how you configure your kernel?
[...]

Correct, it is now mandatory.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

