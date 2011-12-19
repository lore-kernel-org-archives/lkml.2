Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1LSNLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 08:11:54 -0500
Received: from imp03.mtu.ru ([62.5.255.20]:49814 "EHLO imp03.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab1LSNLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 08:11:52 -0500
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Dec 2011 08:11:52 EST
X-AntiVirus: Checked by Dr.Web [version: 6.0.3.08040, engine: 6.0.100.10070, virus records: 2457444, updated: 19.12.2011]
Message-ID: <4EEF3688.5010402@stream.ru>
Date: Mon, 19 Dec 2011 17:05:12 +0400
From: Sergei Shtylyov <braindead@stream.ru>
Organization: Brain-dead Software
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "Greg Kroah-Hartman (supporter:USB SUBSYSTEM ,commit_signer:28/50=56%)" 
	<gregkh@suse.de>,
        "Thomas Dahlmann (supporter:AMD GEODE CS5536...)" 
	<dahlmann.thomas@arcor.de>,
        "Kuninori Morimoto (commit_signer:43/50=86%)" 
	<kuninori.morimoto.gx@renesas.com>,
        "open list:DESIGNWARE USB3 D..." <linux-omap@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:AMD GEODE CS5536..." <linux-geode@lists.infradead.org>
Subject: Re: [PATCH 9/9] usb: gadget: goku: use generic map/unmap routines
References: <1324290632-23758-1-git-send-email-balbi@ti.com> <1324290632-23758-10-git-send-email-balbi@ti.com> <4EEF35FB.9090707@mvista.com>
In-Reply-To: <4EEF35FB.9090707@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 19-12-2011 17:02, Sergei Shtylyov wrote:

>> those routines have everything we need to map/unmap
>> USB requests and it's better to use them.

>> Signed-off-by: Felipe Balbi<balbi@ti.com>
>> ---
>> drivers/usb/gadget/goku_udc.c | 17 +++++++----------
>> 1 files changed, 7 insertions(+), 10 deletions(-)

>> diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
>> index 5af70fcc..bc47735 100644
>> --- a/drivers/usb/gadget/goku_udc.c
>> +++ b/drivers/usb/gadget/goku_udc.c
> [...]
>> @@ -736,10 +732,11 @@ goku_queue(struct usb_ep *_ep, struct usb_request
>> *_req, gfp_t gfp_flags)
>> return -EBUSY;

>> /* set up dma mapping in case the caller didn't */
>> - if (ep->dma&& _req->dma == DMA_ADDR_INVALID) {
>> - _req->dma = pci_map_single(dev->pdev, _req->buf, _req->length,
>> - ep->is_in ? PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
>> - req->mapped = 1;
>> + if (ep->dma) {
>> + status = usb_gadget_map_request(&dev->gadget, &req->req,

> Not '&_req->req'?

    Or just '_req'?

WBR, Sergei
