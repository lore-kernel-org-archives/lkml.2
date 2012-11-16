Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab2KPMhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 07:37:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:45298 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2KPMhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 07:37:17 -0500
Date: Fri, 16 Nov 2012 04:38:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jun Chen <jun.d.chen@intel.com>
Cc: serial <linux-serial@vger.kernel.org>, "russ.gorby" <russ.gorby@intel.com>,
        liu chuansheng <chuansheng.liu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Bi Chao <chao.bi@intel.com>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH] serial: ifx6x60: Add module parameters to manage the
 modem status through sysfs
Message-ID: <20121116123806.GA9303@kroah.com>
References: <1353070789.24092.6.camel@chenjun-workstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353070789.24092.6.camel@chenjun-workstation>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 07:59:49AM -0500, Jun Chen wrote:
> 
> The Medfield Platform implements a recovery procedure consisting in an escalation
> from simple and light recovery procedures to stronger ones with increased visibility
> and impact to end-user.After platform find some problem from Modem,such as no response,
> platform will try do modem warm reset.If several tries failed, platform will try to
> do modem cold boot procedure.For Modem Cold Boot, AP is responsible to generate
> blob (binary object containing PIN code and other necessary information).
> Blob is stored in AP volatile memory. AP decides to read PIN code from cache instead of
> prompting end-user, and sends it to modem as if end-user had entered it.
> 
> This patch add module parameters to manage the modem status through sysfs.
> Reset_modem can be read and write by user space.When read the reset_modem,user space will
> get the mdm_reset_state which used to avoid to run twice at once.When set the reset_modem to
> IFX_COLD_RESET_REQ,modem will do cold reset, other val value will trigger modem reset.
> 
> Hangup_reasons used to give one interface to user space to know and clear the modem reset reasons.
> Now there are four reasons:SPI timeout, modem initiative reset,modem coredump,spi tranfer error.

Why are these module parameters?  Why not just "real" sysfs files
instead?  That way, if you have multiple devices in a system, it will
work properly for them.  Right now you are limited to 1 device, right?

And where have you documented these options?

thanks,

greg k-h
