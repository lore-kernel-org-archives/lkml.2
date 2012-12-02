Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2LBMiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 07:38:54 -0500
Received: from mxout2.netvision.net.il ([194.90.9.21]:48455 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2LBMix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 07:38:53 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <50BB4BB0.90609@gmail.com>
Date: Sun, 02 Dec 2012 14:38:08 +0200
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Arnd Bergmann <arnd@arndb.de>
Cc: Philip Balister <philip@balister.org>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Pavel Machek <pavel@denx.de>, John Linn <john.linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Josh Cartwright <josh.cartwright@ni.com>
Subject: Re: [PATCH 2/2] New driver: Xillybus generic interface for FPGA
 (programmable logic)
References: <1354117293-13632-1-git-send-email-eli.billauer@gmail.com>
 <20121130173644.GA9841@kroah.com> <50B97734.3090207@balister.org>
 <201212012048.51012.arnd@arndb.de>
In-reply-to: <201212012048.51012.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2012 10:48 PM, Arnd Bergmann wrote:
> I agree that is a concern, but for now, I'm mostly worried about
> the kernel-to-user interface. If we can agree on a driver interface
> that works for Xillybus as well as any of the others we know about,
> we can start using that as the generic kernel FPGA interface.
>
> Once we get a second FPGA driver, that can use the same user
> interface but talk to the hardware in a different way, and then
> we can reorganise the code to keep the user interface bits in a
> common driver, away from the hardware specific parts.
>
> If you see anything in the user interface that directly depends on
> the Xillybus IP block, then that would make the approach impossible
> and we should change that to be more generic.
>    

The whole idea about Xillybus was not to invent a new user space 
interface. A lot of effort has been put in to make the device files 
behave like named pipes. For example, it makes perfect sense to go

$ cat mydata > /dev/xillybus_my_data_sink

knowing that the data will arrive as one would expect to the FPGA.


On my next patch submission, I'll include a documentation file, which 
will describe the fine details. But don't expect much on the API side: 
All of the configuration is already done on the hardware (FPGA) side, 
and the driver merely detects the pipes and their attributes.

All that is left for the user space programmer is to exercise common 
UNIX programming practices, and things will work as expected. Or at 
least, this is the intention.

    Eli

