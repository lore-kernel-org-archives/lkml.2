Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761024Ab2CPJns (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:43:48 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43463 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760873Ab2CPJnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:43:47 -0400
Message-ID: <4F630B4D.3040508@suse.cz>
Date: Fri, 16 Mar 2012 10:43:41 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120307 Thunderbird/11.0
MIME-Version: 1.0
To: "Du, Alek" <alek.du@intel.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com> <20120315100812.6cda2ef9@pyramind.ukuu.org.uk> <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 11:14 AM, Du, Alek wrote:
> Alan,
> 
> I agree with you for the case of multiple writers to the tty buffer.
> 
> But there is another case that cause kernel hang: driver is writing data to tty, while app shutdown the port or flush through IOCTL. The buf.tail is set to NULL, here is the log:
> 
> 
> <1>[ 4713.451954] BUG: unable to handle kernel NULL pointer dereference at
> 00000004

The trace only suggests that you don't increment tty reference count in
irq properly. If you did that, you would not have tty buffer gone by
concurrent shutdown.

For the latter case (flush via ioctl), your patch won't help for
tty_prepare_string*, as we return pointer to the buffer which is freed
by the flush, right?

thanks,
-- 
js
suse labs
