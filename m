Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab0IONLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 09:11:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53917 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0IONLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 09:11:05 -0400
Message-ID: <4C90C5B7.7050103@ru.mvista.com>
Date: Wed, 15 Sep 2010 17:10:15 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: balbi@ti.com
CC: Ming Lei <tom.leiming@gmail.com>, Sergei Shtylyov <sshtylyov@mvista.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [Discussion] USB: musb-gadget: how to fix ZLP issue in musb_g_tx
References: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com> <20100915105641.GO3393@legolas.emea.dhcp.ti.com> <AANLkTi=gYSsxSHqAur+isj_UinVLC-YWkdmi5j_vkSUV@mail.gmail.com> <20100915110745.GP3393@legolas.emea.dhcp.ti.com>
In-Reply-To: <20100915110745.GP3393@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Felipe Balbi wrote:

> On Wed, Sep 15, 2010 at 06:02:22AM -0500, Ming Lei wrote:
>> If so, once the dma interrupt comes, will request->actual be same
>> with request->length in musb_g_tx?  And if it is true, could we remove 
>> the
>> check for 'is_dma'?

> see that is_dma is set to true by just checking if dma in enabled in
> txcsr, it might be that dma didn't complete everything and you need to
> write txpktrdy by hand to send last short packet. So to remove that you
> would need to re-work a bit more code.

    I don't see what to rework. The last short packet should still satisfy 
(request->actual == request->length) condition, no?

> You need to know when this is a dma IRQ or an endpoint IRQ.

    We know that -- but why check it there, before (request->actual == 
request->length)?

WBR, Sergei
