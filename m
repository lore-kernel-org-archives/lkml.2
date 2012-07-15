Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2GPDlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 23:41:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51407 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2GPDlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 23:41:09 -0400
Message-ID: <50032BF6.9000704@landley.net>
Date: Sun, 15 Jul 2012 15:45:42 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
CC: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tglx@linutronix.de
Subject: Re: [RESEND PATCH 1/1] clk: add DT support for clock gating control
References: <4FFE7979.4060000@googlemail.com> <4FFEBF8A.1020700@gmail.com> <4FFECC4E.4070001@googlemail.com> <4FFF93DC.30103@gmail.com> <4FFFED7C.9050406@googlemail.com>
In-Reply-To: <4FFFED7C.9050406@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe clock anything is Thomas Gleixner, just making sure he's seen
it...

Rob

On 07/13/2012 04:42 AM, Sebastian Hesselbarh wrote:
> On 07/13/2012 05:19 AM, Rob Herring wrote:
>> What's implemented in Linux should not define the binding. The binding
>> should describe the hardware.
>> [...]
>> True, but not your problem to implement. A binding doesn't necessarily
>> mean there is a full Linux implementation. We just don't want to create
>> something only to find others need something completely different.
> 
> Ok, what about a DT describing the following for a simple register-based
> clock gating controller and the corresponding gated-clock independent of
> the controller. I am sure there are a bunch of SoCs out there that
> control their clock gates by writing some bits to a register. If that
> DT description matches your expectations, I ll prepare patches with
> documentation and implementation for common clock framework.
> 
> Sebastian
> 
> -- 
>  /* Simple clock gating controller based on bitmasks and register */
> cgc: clock-gating-control@f1000000 {
>   compatible = "clock-gating-control-register";
>   reg = <0xf1000000 0x4>;
> 
>   /* Clock gating control with one bit at bit position 0
>      enable with (1<<0), disable with (0<<0) */
>   cgctrl_usb0: cgc_usb0 {
>     clock-gating-control,shift = <0>;
>     clock-gating-control,mask = <1>;
>     clock-gating-control,enable = <1>;
>     clock-gating-control,disable = <0>;
>   };
> 
>   /* Clock gating control with two bits at bit position 1-2
>      enable with (2<<1), disable with (0<<1) */
>   cgctrl_sata: cgc_sata {
>     clock-gating-control,shift = <1>;
>     clock-gating-control,mask = <3>;
>     clock-gating-control,enable = <2>;
>     clock-gating-control,disable = <0>;
>   };
> };
> 
> /* Generic clock gate description that can be used with
>    any clock gating controller */
> cg_usb0: clockgate@0 {
>   compatible = "gated-clock";
>   #clock-cells = <0>;
>   clocks = <&osc>;
>   clock-gate-control = <&cgctrl_usb0>;
> };
> 


-- 
GNU/Linux isn't: Linux=GPLv2, GNU=GPLv3+, they can't share code.
Either it's "mere aggregation", or a license violation.  Pick one.
