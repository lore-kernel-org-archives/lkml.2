Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758Ab2FUQVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 12:21:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34970 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759740Ab2FUQVh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 12:21:37 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206211210510.1164-100000@iolanthe.rowland.org>
References: <CACVXFVM=p3_rqsRF0BWdZ30GW5zgDgy6jbfqNP6xwHJoOQx1Wg@mail.gmail.com>
	<Pine.LNX.4.44L0.1206211210510.1164-100000@iolanthe.rowland.org>
Date: Fri, 22 Jun 2012 00:21:34 +0800
Message-ID: <CACVXFVPYx1mJzdViaNopwi0amvrgqTSqkHRtpgTk7o0txfEw=g@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove(v2)
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 12:12 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 22 Jun 2012, Ming Lei wrote:
>
>> On Thu, Jun 21, 2012 at 9:49 PM, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>
>> > We also have not made the rule that a shutdown will complete in a
>> > specific amount of time either, so there is no problem if that takes a
>> > long time as well.
>>
>> OK, I will submit a new patch which just holds device lock.
>>
>> Alan, do you have objections on the new one?
>
> No objections.  It should end up being pretty much like one of the
> patches you posted earlier.

Holding parent reference count is missed in earlier version.

>
> Should there be an option for a debug log of each device name just
> before its shutdown routine is called?

We have had the below before calling shutdown callback.

          dev_dbg(dev, "shutdown\n");

Thanks,
--
Ming Lei
