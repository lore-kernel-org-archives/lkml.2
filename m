Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab1DNLrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:47:12 -0400
Received: from mail.academy.zt.ua ([82.207.120.245]:4235 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab1DNLrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:47:10 -0400
X-MDAV-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 14:47:09 +0300
X-Spam-Processed: mail.academy.zt.ua, Thu, 14 Apr 2011 14:47:09 +0300
	(not processed: message from trusted or authenticated source)
X-Authenticated-Sender: george@academy.zt.ua
X-Return-Path: george@znau.edu.ua
X-Envelope-From: george@znau.edu.ua
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
From: George Kashperko <george@znau.edu.ua>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
        Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 14 Apr 2011 14:43:51 +0300
Message-Id: <1302781431.21145.6.camel@dev.znau.edu.ua>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-19.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> We have slightly improved our knowledge of new Broadcom's bus. It
> appears Broadcom took standard AMBA bus and put on it two cores for
> every device:
> 1) First core from each pair is real AMBA device, it has CID and PID.
> Broadcom called it wrapper, it is used to control second core
> (enabling second, disabling second, resetting second, setting flags of
> second).
> 2) Second core from each pair is Broadcom specific device. It can
> *not* be treated as standard AMBA core - attempting to read it's CID
> on PID leads to machine hang. Instead it is identified by MANUF, ID,
> REV and CLASS. Example can be 80211 core.
> 
> One of the idea is to integrate with current AMBA driver:
> 1) First driver read info about all cores in Broadcom specific way. It
> registers all *wrapper* (AMBA type) cores as amba_device(s).
> 2) Second driver registers for cores with PID 0x103BB369 (Broadcom
> specific I believe). It receives wrappers (from AMBA bus) and exposes
> wrapper-related Broadcom specific core in the system.
> 
> Problem: how to expose Broadcom specific cores in the system? Remember
> we can not use amba_device, because Broadcom specific cores are
> programmed and identified differently.
> 
> Could we register some virtual bcm_amba bus in the system and register
> Broadcom specific cores with it? Or is there something better for this
> case? In summary everything I need is to make driver (for example b43)
> able to register for Broadcom specific core with Broadcom specific
> identifiers. For example:
> static const struct axi_device_id b43_axi_tbl[] = {
> 	AXI_CORE(AXI_MANUF_BCM, AXI_CORE_80211, 0x17, AXI_ANY_CLASS),
> 	AXI_CORETABLE_END
> };
> MODULE_DEVICE_TABLE(axi, b43_axi_tbl);
> 
> We have problems deciding architecture, the whole proposed layout is
> not approved as final yet. Right now I try to check possibilities.
> 
If you beleive you do need to register broadcom ip core devices on amba
bus then I would suggest you to introduce class driver for broadcom
cores rather than breaking into bus_type layout. But to be honest I
think it is bad idea and your original approach where you managed agents
internally and registered _broadcom_ devices on dedicated _broadcom_ bus
have much more sense. Going your original way you still can also
register agents on amba thus registering two buses per host but honestly
registering them just for the sake of registering makes no sense at all.

Have nice day,
George


