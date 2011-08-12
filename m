Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1HLCXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 22:23:36 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:33058 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1HLCXf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 22:23:35 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo6Fh+zTMiSG+mjkNuA03cCEK7bej9y2oX+HfsScSYGFsw@mail.gmail.com>
References: <1312817901-5313-1-git-send-email-wangshaoyan.pt@taobao.com>
	<CAErSpo6Fh+zTMiSG+mjkNuA03cCEK7bej9y2oX+HfsScSYGFsw@mail.gmail.com>
Date: Fri, 12 Aug 2011 10:23:34 +0800
Message-ID: <CANxBZFrzmTDaUrmkGhKAVsZpXScEDxdJeBzcMbBjEW=6ozppGw@mail.gmail.com>
Subject: Re: [PATCH] pnp: replace deprecated __check_region to request_region
From: Wang Shaoyan <stufever@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, abelay@mit.edu,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

2011/8/12 Bjorn Helgaas <bhelgaas@google.com>:
> We usually funnel PNP stuff through the linux-acpi@vger.kernel.org
> mailing list, so I added a cc: to it.
>

Thanks for your reminding!

> request_region() is not a drop-in replacement for __check_region()
> because __check_region() releases the resource before it returns
> success.  I agree that it would be good to get rid of
> __check_region(), but I think it's a little more work than just this.
>
> I suppose you could just do the release_resource() in
> pnp_check_port(), after request_region() was successful.  But the
> problem with __check_region() is that it's racy, and moving the
> release_resource() into pnp_check_port() doesn't remove the race.  It
> just moves the problem from __check_region() (which is easy to grep
> for) into PNP (where it's not so obvious).
>

I don't think the racy is still exist. In old days, the racy is exist
in this situation:
check_region()
...do something    <-- here another process may do check and request same region
request_region()   <-- if some process request the same resource, it
will fail here

But nowadays, request_region has replaced the check_region, it will
check and request in the same function, so no racy still exist. Am I
right?

> Part of the problem is that the PNP core doesn't actually request any
> of the resources used by PNP devices.  The PCI core *does* reserve
> resources, independent of any drivers, and it would certainly be
> reasonable to expect the PNP core to do the same, but it doesn't.
> This is mostly because there are a bunch of hardcoded legacy resources
> that conflict with PNP devices, and we haven't figured out a good way
> to resolve the conflicts.
>
> Bjorn
>



-- 
Wang Shaoyan
