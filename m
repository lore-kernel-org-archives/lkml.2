Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab1LLXSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:18:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39583 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab1LLXSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:18:20 -0500
Message-ID: <4EE68BB7.7050400@gmail.com>
Date: Mon, 12 Dec 2011 15:18:15 -0800
From: Steve Calfee <stevecalfee@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: USB list <linux-usb@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Busy-waiting with interrupts disabled
References: <Pine.LNX.4.44L0.1112121617400.1864-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1112121617400.1864-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 14:12, Alan Stern wrote:
> How long is it okay to busy-wait with interrupts disabled?  Are there 
> any clear-cut guidelines?
> 
> My feeling is that for ordinary desktop use, 1-2 ms should be about the
> limit, but other people may feel differently.  (There's one spot in
> ehci-hcd where the delay can last up to 250 ms, which does seem rather
> excessive.  Fortunately it never takes that long unless the hardware is
> broken.)
> 

This is a very subjective issue, as to how much is too much. Keep in
mind that when we had 1 MIP computers a delay of 1 to 2 ms would "waste"
from 1000 to 2000 potential instructions. With 3 gighz processors, the
potential waste jumps to 3,000,000 to 6,000,000 instructions. I know
that clock speed does not equal mips and that most processors spend most
of their time waiting for memory, but still, the waste increases with
processor speed.

Regards, Steve
