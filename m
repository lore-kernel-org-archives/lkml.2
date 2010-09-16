Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851Ab0IPLF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 07:05:26 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62621 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab0IPLFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 07:05:25 -0400
Message-ID: <4C91F990.5040901@ru.mvista.com>
Date: Thu, 16 Sep 2010 15:03:44 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: balbi@ti.com
CC: Sergei Shtylyov <sshtylyov@mvista.com>, Ming Lei <tom.leiming@gmail.com>,
        "greg@kroah.com" <greg@kroah.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        "Gadiyar, Anand" <gadiyar@ti.com>, Mike Frysinger <vapier@gentoo.org>
Subject: Re: [Discussion] USB: musb-gadget: how to fix ZLP issue in musb_g_tx
References: <AANLkTinPVUBNJoOR496KgSy2TT0f6i1f5xEKVhKod2R=@mail.gmail.com> <20100915105641.GO3393@legolas.emea.dhcp.ti.com> <AANLkTi=gYSsxSHqAur+isj_UinVLC-YWkdmi5j_vkSUV@mail.gmail.com> <20100915110745.GP3393@legolas.emea.dhcp.ti.com> <4C90C5B7.7050103@ru.mvista.com> <20100916060520.GA3393@legolas.emea.dhcp.ti.com>
In-Reply-To: <20100916060520.GA3393@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-09-2010 10:05, Felipe Balbi wrote:

>> I don't see what to rework. The last short packet should still satisfy
>> (request->actual == request->length) condition, no?

> of course not, it's short not zero. so the last short packet can be
> anything from 1 to 511 bytes.

    Sigh. Where have I said anything different? What I meant is that the last 
short packet is already counted in request->actual, otherwise the condition 
(request->actual & (musb_ep->packet_sz - 1)) wouldn't work.

WBR, Sergei
