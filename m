Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab2KEFp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 00:45:58 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39351 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab2KEFp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 00:45:57 -0500
MIME-Version: 1.0
In-Reply-To: <20121023.023647.2164665243829038911.davem@davemloft.net>
References: <1350885237-12998-1-git-send-email-cardoe@cardoe.com>
	<20121023.023647.2164665243829038911.davem@davemloft.net>
Date: Sun, 4 Nov 2012 23:45:56 -0600
Message-ID: <CAFWqQMSes5J1bjUA6NBiWKrjbdUKJkhz-mdNYhGLU-A8cksxZg@mail.gmail.com>
Subject: Re: [PATCH] vlan: set sysfs device_type to 'vlan'
From: Doug Goldstein <cardoe@cardoe.com>
To: David Miller <davem@davemloft.net>
Cc: kaber@trash.net, netdev@vger.kernel.org,
        systemd-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 1:36 AM, David Miller <davem@davemloft.net> wrote:
> From: Doug Goldstein <cardoe@cardoe.com>
> Date: Mon, 22 Oct 2012 00:53:57 -0500
>
>> Sets the sysfs device_type to 'vlan' for udev. This makes it easier for
>> applications that query network information via udev to identify vlans
>> instead of using strrchr().
>>
>> Signed-off-by: Doug Goldstein <cardoe@cardoe.com>
>
> You're extremely misguided.  This change, in fact, makes it ten times
> harder for such applications to query such devices.
>
> Because now the application has to decide whether it wants to support
> EVERY EXISTING SYSTEM OUT THERE or not.  Hundreds of millions of Linux
> systems do not provide this attribute.
>
> Applications have to handle the case of not having the 'vlan' device
> type available attribute essentially forever.
>
> So providing it in new kernels provides zero value whatsoever.
>
> I'm not applying this patch, sorry.

Dave,

As others on this thread have discussed there are other merits to the
patch as well. Yes you are correct that netlink is the preferred
method to gather information about network devices but the point was
really to make the sysfs layout more correct a matter of completeness.
As Ben Greear pointed out this would allow shell scripts and other
scripting languages to better detect vlans. Kay pointed out that this
would allow better uevent filters in the future as well. So there are
some merits to this patch. If you'd prefer I can resubmit with a
better commit message entailing the reasons behind it.

Thanks.
-- 
Doug Goldstein
