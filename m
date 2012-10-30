Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112Ab2J3Sq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:46:28 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36725 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab2J3SqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:46:25 -0400
Message-ID: <50902079.30406@gmail.com>
Date: Tue, 30 Oct 2012 11:46:17 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] i2c-EEPROM: Export memory accessor
References: <1351699009-4217-1-git-send-email-panto@antoniou-consulting.com>
In-Reply-To: <1351699009-4217-1-git-send-email-panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 08:56 AM, Pantelis Antoniou wrote:
> Various platforms need access to the EEPROM in other
> places besides their platform registration callbacks.
> Export the memory accessor to the i2c_client

i2c_clients are *not* intrinsically memory, so adding this to the 
generic i2c_client structure doesn't really make sense.   What would the 
semantics of this interface be with respect to temperature sensors and 
GPIO expanders?

NACK.


> and implement
> it for the at24 driver.
>
> And before you ask, no, the platform callback can't be used
> for anything that depends on DT.

Why can't you just allocate (and populate) a struct at24_platform_data 
for the device if it isn't supplied by whatever created the device?



