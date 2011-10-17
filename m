Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1JQSdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:33:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64048 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433Ab1JQSdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:33:51 -0400
Message-ID: <4E9C7518.7080005@lwfinger.net>
Date: Mon, 17 Oct 2011 13:34:00 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: wireless <linux-wireless@vger.kernel.org>, v4mp <gaigo88@hotmail.it>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Problem with xhci-hcd and Alfa AWUS036NHR
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am trying to help v4mp <gaigo88@hotmail.it> with a wireless problem.

He is running Ubuntu natty 3.0.4-030004-generic and get the following items in 
his dmesg output:

[    3.963920] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[    3.970920] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[    3.975037] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[    3.976097] usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc 
says 80 microframes
[    3.984899] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep

and later many of

[  545.272708] xhci_hcd 0000:05:00.0: ERROR no room on ep ring

A nearly complete dmesg output is at http://pastebin.com/7tfcBfbD. I asked the 
OP to paste the entire output, but he gave me what is posted there.

Is there a bug in the rtl8192cu USB handling that would let the device work with 
ehci-hcd and ohci-hcd, but fail with xhci-hcd?

Would commit 44f4c3e (USB: xhci: Set change bit when warm reset change is set) 
have any effect on this? I do not know if this is in 3.0.4.

I did not find any other recent commits that are aimed at xhci and looked as if 
they might address this issue. Did I miss any?

Note: The Alfa device works fine on my system with only ohci and ehci controllers.

Thanks,

Larry
