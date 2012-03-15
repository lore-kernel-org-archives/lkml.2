Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161431Ab2COU0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 16:26:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39784 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161254Ab2COU0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 16:26:37 -0400
Date: Thu, 15 Mar 2012 13:26:33 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Du, Alek" <alek.du@intel.com>, "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Message-ID: <20120315202633.GA23975@kroah.com>
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 02:06:43AM +0000, Tu, Xiaobing wrote:
> From: Xiaobing Tu <xiaobing.tu@intel.com>
> 
> tty_buffer_request_room is well protected, but while after it returns,
>  it releases the port->lock. tty->buf.tail might be modified
> by either irq handler or other threads. The patch adds more protection
> by holding the lock across tty buffer finding and buffer filling.
> 
> Signed-off-by: Alek Du <alek.du@intel.com>
> Signed-off-by: Xiaobing Tu <xiaobing.tu@intel.com>
> ---
>  drivers/tty/tty_buffer.c |   85 +++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 65 insertions(+), 20 deletions(-)
>  mode change 100644 => 100755 drivers/tty/tty_buffer.c
> 
> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> old mode 100644
> new mode 100755

What?  Why would you change the mode of the file to be executable?

Also, your patch introduces a bunch of trailing whitespace, please run
it through scripts/checkpatch.pl and fix those issues before resending
it.

thanks,

greg k-h
