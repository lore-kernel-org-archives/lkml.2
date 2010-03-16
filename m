Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab0CPVfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:35:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:34596 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760039Ab0CPVe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:34:58 -0400
Message-ID: <4B9FF976.1060508@windriver.com>
Date: Tue, 16 Mar 2010 16:34:46 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>, Oliver Neukum <oliver@neukum.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] tty_port,usb-console: Fix usb serial consoleopen/close
 regression
References: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com> <1268773546-12457-2-git-send-email-jason.wessel@windriver.com> <20100316212337.GB31739@kroah.com>
In-Reply-To: <20100316212337.GB31739@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Mar 2010 21:34:45.0504 (UTC) FILETIME=[7F2AB000:01CAC550]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 04:23 PM, Greg KH wrote:
> On Tue, Mar 16, 2010 at 04:05:42PM -0500, Jason Wessel wrote:
>> Commit e1108a63e10d344284011cccc06328b2cd3e5da3 ("usb_serial: Use the
>> shutdown() operation") breaks the ability to use a usb console
>> starting in 2.6.33.  This was observed when using
>> console=ttyUSB0,115200 as a boot argument with an FTDI device.  The
>> error is:
>>
>> ftdi_sio ttyUSB0: ftdi_submit_read_urb - failed submitting read urb, error -22
>>
>> The handling of the ASYNCB_INITIALIZED changed in 2.6.32 such that in
>> tty_port_shutdown() it always clears the flag if it is set.  The fix
>> is to add a variable to the tty_port struct to indicate when the tty
>> port is a console.
> 
> I've already applied this to my trees, right?
> 
> 

Correct.  This is also in your tree.   Patches 3-5 are not.

Jason.
