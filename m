Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab2BTKdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:33:03 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4344 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab2BTKdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:33:00 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4F422152.3030603@broadcom.com>
Date: Mon, 20 Feb 2012 11:32:50 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Kay Sievers" <kay.sievers@vrfy.org>
cc: "Larry Finger" <Larry.Finger@lwfinger.net>,
        LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        wireless <linux-wireless@vger.kernel.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>
Subject: Re: will these methods work with firmware loading?
References: <4F414230.5040506@lwfinger.net>
 <4F421A0E.8030805@broadcom.com>
 <CAPXgP10qa_g6R=pOWd8JuXpw0wPdJ4rP7B_4YHDU91mhC0N6Vg@mail.gmail.com>
In-Reply-To: <CAPXgP10qa_g6R=pOWd8JuXpw0wPdJ4rP7B_4YHDU91mhC0N6Vg@mail.gmail.com>
X-WSS-ID: 635CFCEB50424806160-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2012 11:19 AM, Kay Sievers wrote:
>> For that
>> >  problem I would say yes. Also here the problem of handling error flows
>> >  exist. If the driver is kicked of during boot with a initramfs missing the
>> >  firmware, should we retry until the real root is mounted?
> I don't think so. Drivers are not supposed to know about bootup or
> initramfs issues. If they want, they can disable the timeout, and wait
> for userspace to handle the request any time later, but they should
> not try to be smart here.
>
> Currently, firmware requests are cancelled if the firmware isn't
> found, but that's a userspace issue, and nothing the kernel should try
> to work around.

I can not agree more. I prefer to keep my driver happily unaware. I will 
just take the firmware loading away from the module init path and stop 
worrying about userspace issues ;-)

Gr. AvS

