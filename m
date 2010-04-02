Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab0DBRP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:15:27 -0400
Received: from capside.net ([81.19.98.74]:33207 "EHLO eul0600410.eu.verio.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab0DBRPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:15:20 -0400
Message-ID: <4BB62620.3070807@sysvalve.es>
Date: Fri, 02 Apr 2010 19:15:12 +0200
From: =?UTF-8?B?IkwuIEFsYmVydG8gR2ltw6luZXoi?= <agimenez@sysvalve.es>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, oliver@neukum.org, linville@tuxdriver.com,
       j.dumon@option.com, steve.glendinning@smsc.com, davem@davemloft.net,
       gregkh@suse.de, dgiagio@gmail.com, dborca@yahoo.com
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>	 <1270064527-8485-1-git-send-email-agimenez@sysvalve.es> <1270077538.8653.484.camel@localhost>
In-Reply-To: <1270077538.8653.484.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 01:18 AM, Ben Hutchings wrote:
> On Wed, 2010-03-31 at 21:42 +0200, L. Alberto Giménez wrote:
> [...]
>> --- /dev/null
>> +++ b/drivers/net/usb/ipheth.c
> [...]

Hi Ben,

Upstream has fixed several errors pointed out by you and Oliver (thanks
for that), but some of them are still pending.

I will send patches on top of my last driver submission (if the proper
way would be resubmit the whole code, please tell me. Anyway I need to
clarify some doubts...

>> +	usb_fill_bulk_urb(dev->tx_urb, udev,
>> +			  usb_sndbulkpipe(udev, dev->bulk_out),
>> +			  dev->tx_buf, IPHETH_BUF_SIZE,
>> +			  ipheth_sndbulk_callback,
>> +			  dev);
>> +	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
>> +
>> +	retval = usb_submit_urb(dev->tx_urb, GFP_ATOMIC);
>> +	if (retval) {
>> +		err("%s: usb_submit_urb: %d", __func__, retval);
>> +		dev->stats.tx_errors++;
>> +		dev_kfree_skb_irq(skb);
>> +	} else {
>> +		net->trans_start = jiffies;
> 
> No longer needed.

What is not longer needed? The assignment, the whole "else" branch? If
the assignment is what is not needed, can I just remove that line, right?

> [...]
>> +#ifdef HAVE_NET_DEVICE_OPS
>> +static const struct net_device_ops ipheth_netdev_ops = {
>> +       .ndo_open = &ipheth_open,
>> +       .ndo_stop = &ipheth_close,
>> +       .ndo_start_xmit = &ipheth_tx,
>> +       .ndo_tx_timeout = &ipheth_tx_timeout,
>> +       .ndo_get_stats = &ipheth_stats,
>> +};
>> +#endif
> 
> Remove the #ifdef, there is no question whether we have net_device_ops.

Ok, I will just remove both #ifdefs, but why is that? Maybe in previous
versions of the kernel the net_device_ops struct was introduced and now
it's present no matter how you configure your kernel?

> I have no idea about USB so I haven't checked the USB API usage at all.

I think that Greg is the maintainer for the USB subsystem, so if he has
no further commets, I will try to submit fixes for both your and
Oliver's comments along with the upstream developers.

Thanks for your comments.


Best regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
