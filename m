Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab1LVBAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 20:00:01 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44044 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1LVA76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:59:58 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6567"; a="146755371"
Date: Wed, 21 Dec 2011 16:59:56 -0800
From: David Brown <davidb@codeaurora.org>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, john stultz <johnstul@us.ibm.com>,
        Greg KH <gregkh@suse.de>, Brian Swetland <swetland@google.com>
Subject: Re: RFC: android logger feedback request
Message-ID: <20111222005956.GA4862@codeaurora.org>
References: <4EF264C3.6000104@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF264C3.6000104@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 21, 2011 at 02:59:15PM -0800, Tim Bird wrote:

> In Android, this system uses a fixed set of device nodes with
> well-known names: /dev/log/main, /dev/log/events, /dev/log/radio
> and /dev/log/system.

These names seem very specific to Android's use case.  Would we want
the mechanism to be more general, or configurable, so that another
embedded-type system would be able to have their own log types.

But, the biggest question I have is to understand why this is a kernel
driver.  In essence, it is just shuttling data from various processes
to something that eventually needs to read that data.  In other words,
it is doing a subset of what syslog does.  If the concern is about a
userspace program crashing, wouldn't the userspace tool that reads
this data also be able to crash?

The driver clearly has no kernel API, since it exports no symbols.  I
could see more of an argument for it if certain kernel things were
able to write to the log, but then we are also duplicating other
functionality.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
