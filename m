Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab1GAPlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:41:36 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:60205 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab1GAPlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:41:31 -0400
X-Spam-Flag: NO
X-Spam-Score: -22.9
Message-ID: <4E0DEAA8.9020704@tudelft.nl>
Date: Fri, 01 Jul 2011 17:41:28 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Mandriva/3.1.11-1 (2011.0) Thunderbird/3.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Regression 3.0-rc5+ : khubd blocked
References: <Pine.LNX.4.44L0.1107011106380.1988-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1107011106380.1988-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 01-07-11 17:21, Alan Stern schreef:
> On Fri, 1 Jul 2011, Éric Piel wrote:
>
:
> It appears that this was caused by Sarah's commit
> fccf4e86200b8f5edd9a65da26f150e32ba79808 (USB: Free bandwidth when
> usb_disable_device is called).  usb_disconnect() grabs the
> bandwidth_mutex before calling usb_disable_device(), which calls down
> indirectly to usb_set_interface(), which tries to acquire the
> bandwidth_mutex.
>
> This patch should fix the problem.  Still, this whole area cries out
> for some serious rewriting.
>
Thanks Alan,

I was running the regression :-) I'll try the patch and confirm it works.

Éric
