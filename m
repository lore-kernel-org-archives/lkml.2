Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab0DBRyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 13:54:11 -0400
Received: from capside.net ([81.19.98.74]:34896 "EHLO eul0600410.eu.verio.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab0DBRyB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 13:54:01 -0400
Message-ID: <4BB62F33.1020507@sysvalve.es>
Date: Fri, 02 Apr 2010 19:53:55 +0200
From: =?UTF-8?B?IkwuIEFsYmVydG8gR2ltw6luZXoi?= <agimenez@sysvalve.es>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: =?UTF-8?B?IkwuIEFsYmVydG8gR2ltw6luZXoi?= <agimenez@sysvalve.es>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, oliver@neukum.org, linville@tuxdriver.com,
       j.dumon@option.com, steve.glendinning@smsc.com, davem@davemloft.net,
       gregkh@suse.de, dgiagio@gmail.com, Daniel Borca <dborca@yahoo.com>
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es>	 <1270064527-8485-1-git-send-email-agimenez@sysvalve.es>	 <1270077538.8653.484.camel@localhost>  <4BB62620.3070807@sysvalve.es> <1270228883.12516.140.camel@localhost>
In-Reply-To: <1270228883.12516.140.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2010 07:21 PM, Ben Hutchings wrote:
> On Fri, 2010-04-02 at 19:15 +0200, "L. Alberto Giménez" wrote:
>> On 04/01/2010 01:18 AM, Ben Hutchings wrote:
>>> On Wed, 2010-03-31 at 21:42 +0200, L. Alberto Giménez wrote:
>>> [...]
>>>> --- /dev/null
>>>> +++ b/drivers/net/usb/ipheth.c
>>> [...]
>>>> +	usb_fill_bulk_urb(dev->tx_urb, udev,
>>>> +			  usb_sndbulkpipe(udev, dev->bulk_out),
>>>> +			  dev->tx_buf, IPHETH_BUF_SIZE,
>>>> +			  ipheth_sndbulk_callback,
>>>> +			  dev);
>>>> +	dev->tx_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
>>>> +
>>>> +	retval = usb_submit_urb(dev->tx_urb, GFP_ATOMIC);
>>>> +	if (retval) {
>>>> +		err("%s: usb_submit_urb: %d", __func__, retval);
>>>> +		dev->stats.tx_errors++;
>>>> +		dev_kfree_skb_irq(skb);
>>>> +	} else {
>>>> +		net->trans_start = jiffies;
>>> No longer needed.
>> What is not longer needed? The assignment, the whole "else" branch? If
>> the assignment is what is not needed, can I just remove that line, right?
> 
> The assignment is not needed.

Hi,

I've been looking into this and it seems that the net_device.trans_start
field is now deprecated in favor of net_device.rx_queue.trans_start
-rx_queue is a struct netdev_queue- (file include/linux/netdevice.h), as
states the comment:

512         /*
513          * please use this field instead of dev->trans_start
514          */
515         unsigned long           trans_start;

Reading LDD3 book, it says that the driver is reponsible for updating
trans_start (as well as trans_rx, but we're not talking about that one).

So, I guess that the LDD book is outdated (again ;) ), but what I don't
understand at all is wether the driver should keep updating the right
field (dev->rx_queue.trans_start) or if the fact that it's inside a
"queue" implies that the code that is responsible for that queue would
update the trans_start field by itself?

Thanks in advance.

Best regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
