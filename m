Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621Ab2AFVVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 16:21:08 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44920 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030573Ab2AFVVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 16:21:06 -0500
X-Sasl-enc: mAB4v2+gKX8jrPvzwUXLyzikLVaIGuMgjRW/c6bfSOtU 1325884864
Date: Fri, 6 Jan 2012 13:04:23 -0800
From: Greg KH <greg@kroah.com>
To: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] jsm: Fixed EEH recovery error
Message-ID: <20120106210423.GA19379@kroah.com>
References: <1315834565-9280-1-git-send-email-lucaskt@linux.vnet.ibm.com>
 <20110912153508.GA8851@oc1711230544.ibm.com>
 <4F075D02.3010407@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F075D02.3010407@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 06, 2012 at 06:43:46PM -0200, Lucas Kannebley Tavares wrote:
> 
> On 09/12/2011 12:35 PM, Thadeu Lima de Souza Cascardo wrote:
> >On Mon, Sep 12, 2011 at 10:36:05AM -0300, Lucas Kannebley Tavares wrote:
> >>There was an error on the jsm driver that would cause it to be unable to
> >>recover after a second error is detected.
> >>
> >>At the first error, the device recovers properly:
> >>
> >>[72521.485691] EEH: Detected PCI bus error on device 0003:02:00.0
> >>[72521.485695] EEH: This PCI device has failed 1 times in the last hour:
> >>...
> >>[72532.035693] ttyn3 at MMIO 0x0 (irq = 49) is a jsm
> >>[72532.105689] jsm: Port 3 added
> >>
> >>However, at the second error, it cascades until EEH disables the device:
> >>
> >>[72631.229549] Call Trace:
> >>...
> >>[72641.725687] jsm: Port 3 added
> >>[72641.725695] EEH: Detected PCI bus error on device 0003:02:00.0
> >>[72641.725698] EEH: This PCI device has failed 3 times in the last hour:
> >>
> >>It was caused because the PCI state was not being saved after the first
> >>restore. Therefore, at the second recovery the PCI state would not be
> >>restored.
> >>
> >>Signed-off-by: Lucas Kannebley Tavares<lucaskt@linux.vnet.ibm.com>
> >Signed-off-by: Breno Leitao <brenohl@br.ibm.com>
> >Acked-by: Thadeu Lima de Souza Cascardo<cascardo@linux.vnet.ibm.com>
> 
> Adding Greg to the CC list. It wasn't added earlier because
> get_maintainers.pl only listed Alan's name. I apologize for the
> delay.
> 
> This is a bugfix to EEH handling on jsm.

Can someone send me a patch in a format that I could actually apply it
in?

thanks,

greg k-h
