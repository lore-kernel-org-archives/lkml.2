Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab2GLNIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 09:08:35 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46210 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab2GLNIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 09:08:34 -0400
Message-ID: <4FFECC4E.4070001@googlemail.com>
Date: Thu, 12 Jul 2012 15:08:30 +0200
From: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RESEND PATCH 1/1] clk: add DT support for clock gating control
References: <4FFE7979.4060000@googlemail.com> <4FFEBF8A.1020700@gmail.com>
In-Reply-To: <4FFEBF8A.1020700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 02:14 PM, Rob Herring wrote:
>> +Required child properties:
>> +- reg : should contain the individual bit and polarity to control
>> +        the clock gate. A polarity of 0 means that by setting the
>> +        bit to 1 the clock passes through the clock gate while
>> +    setting the bit to 0 disables the clock. Any other value
>> +         for polarity inverts the meaning of the control bit.
>
> This is a bit of overloading reg to specify the polarity.

Well, yes it is overloading but still matches reg somehow, as the
extra information is required to access the resource. But I agree,
expecially wrt more-than-one-bit clk-gate (see below).

>> +        /* SATA clock gate with different parent clock */
>> +        cg_sata: clockgate@3 {
>> +            reg =<3 0>; /* register bit 3, normal polarity */
>> +            clocks =<&sata_clk>;
>> +        };
>
> I'm not sure I like the node per bit. What about a bit mask for valid
> bits and polarities. Then add a clock cell to specify the bit or index.
>
> i.MX has 2-bit enable fields for its leaf clocks, so how and if you
> would support that is something to think about.

Yeah, I thought of "what if the clk_gate needs to be enabled with more
than 1 bit" already. But this is a short-comming of the current clk-gate
implementation.

Just to get it right, i.MX requires to set more than one bit to change
the state of the gate for one leaf clock?

If this is true, that would require a change of the generic clk-gate
anyway.

I had a look at pinctrl-bindings.txt maybe this is the way to go for
clock gating control, too. That would require clk-gate to handle an
'active' and 'gated' state and leave it to a clock gate control to
actually set the required bits in any registers. This would allow
other special implementations of clock gating controllers to reuse
clk-gate DT description. Additionally, there could be a
simple-clock-gating-control that can set states by reg address and
for each controlled gate a mask, enable value, and disable value.

Sebastian
