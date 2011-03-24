Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab1CXMIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:08:00 -0400
Received: from realvnc.com ([146.101.152.142]:60930 "EHLO realvnc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754639Ab1CXMH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:07:59 -0400
Message-ID: <4D8B341C.4010406@realvnc.com>
Date: Thu, 24 Mar 2011 12:07:56 +0000
From: Toby Gray <toby.gray@realvnc.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: balbi@ti.com
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stefan Bigler <stefan.bigler@keymile.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
References: <4D8121F6.9060600@keymile.com> <20110317000408.GA18911@kroah.com> <4D8389EC.5030704@keymile.com> <20110318170801.GA2857@legolas.emea.dhcp.ti.com> <20110318180657.11570887@lxorguk.ukuu.org.uk> <20110321093255.GE1837@legolas.emea.dhcp.ti.com> <20110322085344.GN1837@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110322085344.GN1837@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/03/2011 08:53, Felipe Balbi wrote:
> Patch attached, please give it a good round of test as I don't have how
> to exercise all line disciplines. I ran 100 randconfigs over night and
> no warnings or erros on that area, at least not that I could see (so
> many warning while compiling the kernel :-( )

Is this patch missing the changes to tty_buffer.c that were in 
http://permalink.gmane.org/gmane.linux.usb.general/28976

Without the changes to tty_buffer.c to use the value returned from the 
receive_buf call then doesn't this patch not work correctly?

Also with this patch, does the receive_room member of tty_struct have 
any use? As far as I can tell it's also referenced in paste_selection in 
drivers/tty/vt/selection.c. It's the case that past_selection uses 
receive_buf so shouldn't it be updated to use the new return value 
semantics for receive_buf?

Without modifying tty_buffer.c to not make use of receive_room I can't 
get console terminals to work with this patch. Although I have to admit 
that I've been applying the patch to 2.6.35.3 as that's the kernel my 
development board is currently using, but I can't see any immediate 
reason why the most recent kernel would be any different. However I'm 
still fairly new to the interactions between the various bits of tty 
code and drivers, so I could just be missing an important change that's 
in 2.6.38+.

Regards,

Toby

