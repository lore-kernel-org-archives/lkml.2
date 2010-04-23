Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab0DWRwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 13:52:10 -0400
Received: from relay.ihostexchange.net ([66.46.182.52]:17672 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756388Ab0DWRwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 13:52:08 -0400
Message-ID: <4BD1DE30.5030405@VirtualLogix.com>
Date: Fri, 23 Apr 2010 19:51:44 +0200
From: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: USBIP (staging) driver's dependency on drivers/usb/core internal
 headers
References: <Pine.LNX.4.44L0.1004231246440.1777-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004231246440.1777-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Fri, 23 Apr 2010, Eric Lescouet wrote:
> 
>> If I understand correctly, splitting hub.h into hub.h + ch11.h is 
>> independent of the move. At the end the 2 (or 3 files) would end up
>> into include/linux/usb/.
>> correct?
> 
> Two files.  The first would be ch11.h (or maybe keep the name hub.h; 
> I'm not sure which is best), and the second would be hcd.h (including 
> the leftover parts from the original hub.h).
> 

OK. understood now ;-)

>> I've tried to move hub.h and hcd.h and to compile the kernel, already.
>> Changing the path of the #include directives in ~40 files did the trick.
>>
>> Would you like 2 patches (move and then split) or only 1?
> 
> If it weren't for the rename, I'd say do it in two patches.  But if the 
> name is changed to ch11.h then those 40 files would have to be altered 
> twice.
> 
> Alan Stern
> 

Well, most of the files include hcd.h (which includes hub.h),
only ~4 of them directly use hub.h.
So what's your vote? rename hub.h into ch11.h?

	Eric.

