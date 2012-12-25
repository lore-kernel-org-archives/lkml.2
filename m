Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab2LYSGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 13:06:43 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55121 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753943Ab2LYSGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 13:06:41 -0500
Message-ID: <50D9EB2E.9000105@lwfinger.net>
Date: Tue, 25 Dec 2012 12:06:38 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Regression in kernel 3.8-rc1 bisected to commit adfa79d: I now
 get many "unable to enumerate USB device" messages
References: <Pine.LNX.4.44L0.1212251122520.32342-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1212251122520.32342-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/25/2012 10:26 AM, Alan Stern wrote:
> On Mon, 24 Dec 2012, Larry Finger wrote:
>
>> The problem has been bisected to commit adfa79d entitled "USB: EHCI: make
>> ehci-pci a separate driver". The symptom is that my NVIDIA controller again
>> reverts to unended logging of messages of the form "hub 2-0:1.0: unable to
>> enumerate USB device on port 5".
>
> A few more details would be helpful, such as the dmesg log (with
> CONFIG_USB_DEBUG enabled).  As it is, I don't see how that commit could
> cause this problem.  It should not have resulted in any changes in
> behavior -- all it did was split up a driver that was one module into
> two modules.
>
>> This behavior was previously fixed with commit c618759.
>
> That commit affected the ohci-hcd driver, whereas this one affects
> ehci-hcd.  They can't possibly be related.

Alan,

You are the expert, but I am confident of my bisection. A kernel built from 
commit 3e02320 does not have the problem, but commit adfa79d does.

The dmesg output with CONFIG_USB_DEBUG enabled is posted at
http://susepaste.org/790689.

Thanks for looking at this.

Larry


