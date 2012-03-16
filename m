Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032609Ab2CPKES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:04:18 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37824 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030931Ab2CPKER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:04:17 -0400
Message-ID: <4F63101D.70507@suse.cz>
Date: Fri, 16 Mar 2012 11:04:13 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120307 Thunderbird/11.0
MIME-Version: 1.0
To: "Du, Alek" <alek.du@intel.com>
CC: "jiris >> Jiri Slaby" <jirislaby@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com> <20120315100812.6cda2ef9@pyramind.ukuu.org.uk> <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com> <4F630B4D.3040508@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com> <4F630E6D.4000307@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 11:01 AM, Du, Alek wrote:
> We prepared the buffer, and use it. And during this, we don't release the spinlock of buf.lock, how the flush could happen?
> 
>                A
> spin_lock
> prepare the buffer
> user the buffer
> spin unlock
> 
> 
>               B
> Spin_lock
> Flush
> Free the buffer
> Put buf.tail = NULL
> Spin unlock

Well, you do. Not all drivers use tty_insert_flip_string. Take a look at
tty_prepare_flip_string and its users.

thanks,
-- 
js
suse labs
