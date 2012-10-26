Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab2JZHnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:43:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44332 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab2JZHnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:43:49 -0400
Date: Fri, 26 Oct 2012 03:43:48 -0400 (EDT)
Message-Id: <20121026.034348.679271630151161129.davem@davemloft.net>
To: oneukum@suse.de
Cc: hemantk@codeaurora.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] net: usb: Fix memory leak on Tx data path
From: David Miller <davem@davemloft.net>
In-Reply-To: <4122165.gxBpJlT6o2@linux-lqwf.site>
References: <1351225074-2078-1-git-send-email-hemantk@codeaurora.org>
	<4122165.gxBpJlT6o2@linux-lqwf.site>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>
Date: Fri, 26 Oct 2012 09:39:16 +0200

> On Thursday 25 October 2012 21:17:54 Hemant Kumar wrote:
>> Driver anchors the tx urbs and defers the urb submission if
>> a transmit request comes when the interface is suspended.
>> Anchoring urb increments the urb reference count. These
>> deferred urbs are later accessed by calling usb_get_from_anchor()
>> for submission during interface resume. usb_get_from_anchor()
>> unanchors the urb but urb reference count remains same.
>> This causes the urb reference count to remain non-zero
>> after usb_free_urb() gets called and urb never gets freed.
>> Hence call usb_put_urb() after anchoring the urb to properly
>> balance the reference count for these deferred urbs. Also,
>> unanchor these deferred urbs during disconnect, to free them
>> up.
> 
> Good catch. This needs to go into stable, too.
>> 
>> Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
> Acked-by: Oliver Neukum <oneukum@suse.de>

Applied and queued up for -stable.
