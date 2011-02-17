Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab1BQV63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:58:29 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62209 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab1BQV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:58:26 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6260"; a="74886911"
Message-ID: <4D5D9A00.7060609@codeaurora.org>
Date: Thu, 17 Feb 2011 13:58:24 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jamie Iles <jamie@jamieiles.com>
CC: John Linn <john.linn@xilinx.com>, linux@arm.linux.org.uk, arnd@arndb.de,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        glikely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3 3/4] ARM: Xilinx: base header files and assembly macros
References: <1297872716-13353-1-git-send-email-john.linn@xilinx.com>	<1297872716-13353-2-git-send-email-john.linn@xilinx.com>	<1297872716-13353-3-git-send-email-john.linn@xilinx.com>	<e58673f5-2881-4820-b5cd-99e8ef294ed5@VA3EHSMHS024.ehs.local> <20110217100126.GD22961@pulham.picochip.com>
In-Reply-To: <20110217100126.GD22961@pulham.picochip.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 02:01 AM, Jamie Iles wrote:
>> +
>> +static void putc(char ch)
>> +{
>> +	/*
>> +	 * Wait for room in the FIFO, then write the char into the FIFO
>> +	 */
>> +	while (UART_STATUS(LL_UART_PADDR) & UART_SR_TXFULL)
>> +		;
>
> It might be worth adding a barrier() call to these loops to be explicit 
> about the volatility.

I think you want cpu_relax() then.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

