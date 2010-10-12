Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab0JLHVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 03:21:41 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15044 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab0JLHVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 03:21:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6133"; a="57462683"
Message-ID: <3bcbaf2980892d18960a399f235fd993.squirrel@www.codeaurora.org>
In-Reply-To: <Pine.LNX.4.44L0.1010101648230.30042-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1010101648230.30042-100000@netrider.rowland.org>
Date: Tue, 12 Oct 2010 00:21:32 -0700 (PDT)
Subject: Re: [RFC/PATCH 2/2] usb: Adding SuperSpeed support to dummy_hcd
From: "Brokhman Tatyana" <tlinder@codeaurora.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
Cc: "Tatyana Brokhman" <tlinder@codeaurora.org>, linux-usb@vger.kernel.org,
        "David Brownell" <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
Reply-To: tlinder@codeaurora.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan

Thanks you for your comments. Please see my reply inline.

Best Regards,
Tanya Brokhman

> On Sun, 10 Oct 2010, Tatyana Brokhman wrote:
>
>> USB 3.0 hub includes 2 hubs - HS and SS ones.
>> Thus, when dummy_hcd enabled it will register 2 root hubs (SS and HS).
>>
>> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>> ---
>>  drivers/usb/gadget/dummy_hcd.c |  739
>> +++++++++++++++++++++++++++++++++-------
>>  1 files changed, 616 insertions(+), 123 deletions(-)
>
> I'd appreciate if you break this up into two patches.  Separating out
> handle_control_request into a separate function is independent of the
> USB-3.0 conversion.

You're right about that. Will do.
I'll wait for others to review and send an updated patch soon.

>Also, you should update the kerneldoc title line
> for handle_control_request: the format is wrong and it contains a
> spelling error.  (The format of the kerneldoc for the other new
> routines in this patch is also wrong.)

Will be fixed in the next patch version.

> In addition, I suspect the dummy_hcd driver structure shouldn't contain
> an address_device entry.  It should be present only in dummy_ss_hcd.

I'm not sure I follow...
According to the code and comments in hub.c address_device cb is used if
the host controller wishes to choose the device address itself instead of
the address chosen by the core. It seems to me that there is nothing
preventing the dummy_hcd from supplying such cb as well. Is there?
Having both HS and SS dummy_hcd determine the device address seems more
convenient for testing proposes.

> Alan Stern
>
>


-- 
Sent by an consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


