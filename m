Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab1ASRb5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 12:31:57 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23707 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1ASRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 12:31:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6231"; a="71110599"
From: David Brown <davidb@codeaurora.org>
To: Jamie Iles <jamie@jamieiles.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, rlove@google.com
Subject: Re: [PATCH 2/2] serial: msm: Add support for UARTDM cores
In-Reply-To: <20110119082534.GA9569@gallagher> (Jamie Iles's message of "Wed,
	19 Jan 2011 08:25:34 +0000")
References: <1295407585-18386-1-git-send-email-stepanm@codeaurora.org>
	<20110119082534.GA9569@gallagher>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
X-Hashcash: 1:20:110119:linux-kernel@vger.kernel.org::CBP5fsJa0S9O0BXw:0000000000000000000000000000000001aIJ
X-Hashcash: 1:20:110119:stepanm@codeaurora.org::P9ZQxynOFCtjAJ5V:0000000000000000000000000000000000000004KrT
X-Hashcash: 1:20:110119:jamie@jamieiles.com::xfaFDl7zbFz6Twnj:000000000000000000000000000000000000000000B0Xj
X-Hashcash: 1:20:110119:linux-arm-msm@vger.kernel.org::F9ChyC4/CxMfVxdJ:00000000000000000000000000000000DUOf
X-Hashcash: 1:20:110119:linux-arm-kernel@lists.infradead.org::gF6Qx4kP9wAjd/N2:0000000000000000000000000A2LO
X-Hashcash: 1:20:110119:rlove@google.com::cVvGX2UEtG8UsBmu:0CtKp
Date: Wed, 19 Jan 2011 09:31:55 -0800
Message-ID: <8yaaaiwsstw.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19 2011, Jamie Iles wrote:

>> @@ -38,9 +40,20 @@ struct msm_port {
>>  	struct uart_port	uart;
>>  	char			name[16];
>>  	struct clk		*clk;
>> +	struct clk		*pclk;
>>  	unsigned int		imr;
>> +	unsigned int            *gsbi_base;
>> +	int			is_dm;
>> +	unsigned int		old_snap_state;
>>  };
>
> Out of interest, what does .is_dm mean?  Is that obvious to someone who 
> knows about msm?

It would be clear to people rather familiar with the chip, but I agree
it's probably not that clear of a name.

We have two UART blocks we use in the MSMs, the older one, supported by
this driver before this change, and a newer one that was designed to
work with our DMA engine (known as the Data Mover, or dm).  This newer
UART can be used in a somewhat compatible manner when being used for
serial-port type operations.

I'm not sure what would be a better name for the flag, though.  The
block is called UARTDM.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
