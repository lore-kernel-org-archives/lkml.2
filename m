Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab2CMVPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:15:25 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41851 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab2CMVPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:15:23 -0400
Message-ID: <4F5FB8E8.7010102@gmail.com>
Date: Tue, 13 Mar 2012 16:15:20 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: b29396@freescale.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] of: add NULL parameter check for of_device_is_available
References: <1331638805-17136-1-git-send-email-b29396@freescale.com> <20120313.133419.2242081944811028058.davem@davemloft.net>
In-Reply-To: <20120313.133419.2242081944811028058.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 03:34 PM, David Miller wrote:
> From: Dong Aisheng <b29396@freescale.com>
> Date: Tue, 13 Mar 2012 19:40:05 +0800
> 
>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>
>> This function will return 1 even the device node passed in
>> is NULL which is a little error-prone.
>> Change to return 0 if the device node passed in is NULL.
>>
>> Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> I think this is a hard error and therefore BUG_ON(!device) is
> more appropriate.

Shouldn't removing a node from the dts and adding 'status = "disabled";'
to a node give the same behavior? Then you can do something like this:

if (of_device_is_available(of_find_compatible_node("blah")))
	//foo

Rob
