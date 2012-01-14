Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2ANHyG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 02:54:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38330 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab2ANHyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 02:54:04 -0500
Message-ID: <4F113493.3030701@gmail.com>
Date: Sat, 14 Jan 2012 15:53:55 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Feng Ye <f_ye@yahoo.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to wait for threaded irq handler to finish, as in work queue
 flush/cancel?
References: <1326519475.54455.YahooMailNeo@web112702.mail.gq1.yahoo.com> <1326519648.92006.YahooMailNeo@web112707.mail.gq1.yahoo.com>
In-Reply-To: <1326519648.92006.YahooMailNeo@web112707.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2012 01:40 PM, Feng Ye wrote:
> Hello there,
>
>
> I have a question regarding how to cancel threaded irq handler in a driver's suspend function.
> If it's NOT threaded irq, normally you have a work queue, and in the suspend function, you call either cancel_work_sync() or flush_work(), these function will WAIT for the work queue to finish if it's in the middle of something.
> However if you use threaded irq, then you don't need a work queue, then in the suspend function, I don't know if there's a simple function that can be used to cancel and wait the thread to finish?
>
>

Hi,

Isn't free_irq() what you want?

/**
  *      free_irq - free an interrupt allocated with request_irq
  *      @irq: Interrupt line to free
  *      @dev_id: Device identity to free
  *
  *      Remove an interrupt handler. The handler is removed and if the
  *      interrupt line is no longer in use by any driver it is disabled.
  *      On a shared IRQ the caller must ensure the interrupt is disabled
  *      on the card it drives before calling this function. The function
  *      does not return until any executing interrupts for this IRQ
  *      have completed.
  *
  *      This function must not be called from interrupt context.
  */

