Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539Ab2FEJio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:38:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab2FEJim convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:38:42 -0400
MIME-Version: 1.0
In-Reply-To: <20120605091858.GA20917@kroah.com>
References: <1338886747-28088-1-git-send-email-ming.lei@canonical.com>
	<20120605091858.GA20917@kroah.com>
Date: Tue, 5 Jun 2012 17:38:39 +0800
Message-ID: <CACVXFVObp-DYjBGBiVjDdmD6P-bsh-xO79fxSxGqDWbRyk0Anw@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix shutdown races with probe/remove
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 5, 2012 at 5:18 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Tue, Jun 05, 2012 at 04:59:07PM +0800, Ming Lei wrote:
>> Firstly, .shutdown callback may touch a uninitialized hardware
>> if dev->driver is set and .probe is not completed.
>
> When would that ever happen?

It may happen when someone plugs a device, then run 'shutdown' immediately.

>
>> Secondly, device_shutdown() may dereference a null pointer to cause
>> oops when dev->driver is cleared after it is checked in device_shutdown().
>
> Again, when would that happen?  A new device/driver being added to the
> system as it is being shutdown?

It is usually that someone presses 'power off' button and unplugs
its usb devices or pci/e devices, maybe together with a new plug.

In such case, the oops may be triggered.

>
> Has anyone ever hit that before?

Looks someone has reported it, I also can trigger it
with some delay added in device_shutdown.

>
> Is this really needed?

In case that it is triggered, oops will prevent system from being
shutdown, and it should be a big problem.

IMO, we can avoid it without much change and side effect, so
looks worthy the change.

Thanks,
--
Ming Lei
