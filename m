Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab0KVH4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:56:04 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62767 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0KVH4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:56:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S7sd1VzEJya4jO9ic2KbERbNDLxzGJouRTy2g3iVs+J8E0bE4j6CUuehnhjAIDEB0k
         ImRGB9sqUzCzhVpiRgrK32YxS+st69ZGiFQEFtb1pRooKi2fMeLJqFmuRtFf5aVdqA9u
         tVukGMvdjOzcI0vzW6+GbrCWXPU5nW9Z37LhU=
Date: Sun, 21 Nov 2010 23:55:55 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: linux-kernel@vger.kernel.org, jkosina@suse.cz,
        Ping Cheng <pingc@wacom.com>
Subject: Re: [PATCH] Add BTN_TOOL_BUTTONS to input.h
Message-ID: <20101122075554.GA27300@core.coreip.homeip.net>
References: <1290126335-12430-1-git-send-email-pingc@wacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290126335-12430-1-git-send-email-pingc@wacom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ping,

On Thu, Nov 18, 2010 at 04:25:35PM -0800, Ping Cheng wrote:
> We "borrowed" BTN_TOOL_FINGER from input/mouse to pass tablet
> buttons to the user land. This has not been an issue since
> tablet was not considered as a mouse replacement. With the
> introduction of hybrid digitizer and touch devices, the tool
> type is causing confusion. A new tool type is due for the
> well-being of future input device drivers.
> 

I am sorry but I do not understand the reasoning behind
BTN_TOOL_BUTTONS.

The BTN_TOOL_* were introduced to indicate to the userspace tool that is
currently touching the surface of the device. Buttons are expected to be
always present and can change their state regardless of what tool is
being used at the moment. I.e. The full hardware state (between
EV_SYN/SYN_REPORT) could be, for example,

Pen at 10,20, BTN_0, and BTN_2 (ABS_X 10, ABS_Y 20, BTN_TOOL_PEN, BTN_0,
BTN_2) or

Lens at 20,15 and BTN_1 (ABS_X 20, ABS_Y 15, BTN_TOOL_LENS, BTN_1).

As you can see BTN_* events can accompany either BTN_TOOL_LENS or
BTN_TOOL_PEN or any other BTN_TOOL_*.

Thanks.

-- 
Dmitry
