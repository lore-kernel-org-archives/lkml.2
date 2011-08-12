Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab1HLPMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:12:03 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:58147 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1HLPMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:12:00 -0400
Date: Fri, 12 Aug 2011 08:11:45 -0700 (PDT)
Message-Id: <20110812.081145.1237768611581199187.davem@davemloft.net>
To: jwboyer@redhat.com
Cc: oliver@neukum.org, alexey.orishko@stericsson.com, gregkh@suse.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] usbnet/cdc_ncm: Don't use stack variables for DMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110812150715.GD3014@zod.bos.redhat.com>
References: <20110808123406.GA2526@zod.bos.redhat.com>
	<20110812150715.GD3014@zod.bos.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 12 Aug 2011 08:11:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>
Date: Fri, 12 Aug 2011 11:07:16 -0400

> On Mon, Aug 08, 2011 at 08:34:06AM -0400, Josh Boyer wrote:
>> The cdc_ncm driver still has a few places where stack variables are
>> passed to the cdc_ncm_do_request function.  This triggers a stack trace in
>> lib/dma-debug.c if the CONFIG_DEBUG_DMA_API option is set.
>> 
>> Adjust these calls to pass parameters that have been allocated with
>> kzalloc.
>> 
>> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
>> ---
>> v4: Rebase against 3.1-rc1
>> v3: Fix checkpatch errors
>> v2: Fix leak in error path
>> 
>>  drivers/net/usb/cdc_ncm.c |   47 ++++++++++++++++++++++++++++++++++++--------
>>  1 files changed, 38 insertions(+), 9 deletions(-)
> 
> Just curious, but which tree would this be pulled into?  usb or net or?

Probably net.
