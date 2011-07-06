Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1GFPkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 11:40:12 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:36911 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1GFPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 11:40:10 -0400
Message-ID: <4E14816C.7070001@mvista.com>
Date: Wed, 06 Jul 2011 19:38:20 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: Weird USB over-current messages in recent kernels...
References: <Pine.LNX.4.44L0.1107061048160.1995-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1107061048160.1995-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Alan Stern wrote:

>> Seen during boot the last few days on my laptop:

>> running 3.0.0-rc4-mmotm0622:
>> Jul  2 13:08:37 turing-police kernel: [    2.788108] hub 2-0:1.0: over-current condition on port 1
>> Jul  2 13:08:37 turing-police kernel: [    2.990088] hub 2-0:1.0: over-current condition on port 2
>> Jul  2 13:08:37 turing-police kernel: [    3.193073] hub 6-0:1.0: over-current condition on port 1
>> Jul  2 13:08:37 turing-police kernel: [    3.395088] hub 6-0:1.0: over-current condition on port 2

>> running 3.0.0-rc5-mmotm0630:
>> Jul  5 09:43:36 turing-police kernel: [  203.686082] hub 6-0:1.0: over-current condition on port 1
>> Jul  5 09:43:36 turing-police kernel: [  203.969179] hub 6-0:1.0: over-current condition on port 2
>> Jul  5 09:43:36 turing-police kernel: [  204.217077] hub 6-0:1.0: over-current condition on port 1

>> The problem?  I don't see any devices that would *cause* the condition:

>> The device 5 and 6 on bus 1 are attached to the docking station, the Jul 2 boot
>> was undocked and those two devices weren't present. Nobody home on bus 2 or 6
>> at any time, as far as I can tell.

>> Any ideas?

> That message was added recently, which may explain why you haven't seen 
> it before.

    Wasn't there a similar dev_err() message before that patch that added this 
message (the previous message was printed on any over-current signal change)?

> For more debugging, please collect a usbmon log for bus 2 or bus 6 (see 
> Documentation/usb/usbmon.txt).  In fact, you might try doing this for 
> an earlier kernel as well.

> It may be that your host controllers claim that an over-current
> condition exists when it really doesn't, or it may be that those ports
> are wired incorrectly and really do have an over-current condition.

    If it's EHCI driver, there's module option to suppress over-current 
checking, called 'ignore_oc'. It should help with bogus over-current signalling...

> Alan Stern

WBR, Sergei
