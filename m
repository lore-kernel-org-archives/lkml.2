Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab2J3Sv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:51:26 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:53387 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932341Ab2J3SvX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:51:23 -0400
Subject: Re: [PATCH] i2c-EEPROM: Export memory accessor
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <50902079.30406@gmail.com>
Date: Tue, 30 Oct 2012 20:51:18 +0200
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <4AF9EE5B-D1C1-45E7-B2FD-E96151F5772A@antoniou-consulting.com>
References: <1351699009-4217-1-git-send-email-panto@antoniou-consulting.com> <50902079.30406@gmail.com>
To: David Daney <ddaney.cavm@gmail.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Oct 30, 2012, at 8:46 PM, David Daney wrote:

> On 10/31/2012 08:56 AM, Pantelis Antoniou wrote:
>> Various platforms need access to the EEPROM in other
>> places besides their platform registration callbacks.
>> Export the memory accessor to the i2c_client
> 
> i2c_clients are *not* intrinsically memory, so adding this to the generic i2c_client structure doesn't really make sense.   What would the semantics of this interface be with respect to temperature sensors and GPIO expanders?
> 
> NACK.
> 

It's only filled in for EEPROM devices. There's no other I2C memory read interface for kernel clients.

> 
>> and implement
>> it for the at24 driver.
>> 
>> And before you ask, no, the platform callback can't be used
>> for anything that depends on DT.
> 
> Why can't you just allocate (and populate) a struct at24_platform_data for the device if it isn't supplied by whatever created the device?
> 
> 
> 

There are no platform_data in the case of device tree only generic-boards. Everything is configured via the DT and there are
no callbacks. DT is a purely data driver concept.

I'm open to suggestions on how to read an EEPROM from another kernel client, when there's no such thing as platform_data anymore.

Regards

-- Pantelis



