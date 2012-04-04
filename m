Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671Ab2DDAtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 20:49:42 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:35766 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863Ab2DDAtk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 20:49:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120403155703.3B0593E053F@localhost>
References: <1333348747-12713-1-git-send-email-tinamdar@apm.com>
	<1333348747-12713-2-git-send-email-tinamdar@apm.com>
	<1333348747-12713-3-git-send-email-tinamdar@apm.com>
	<20120403155703.3B0593E053F@localhost>
Date: Tue, 3 Apr 2012 20:49:40 -0400
Message-ID: <CA+5PVA4_PJ2T7LGM_N_WemQKY2u6bLg0QFk4wPpd=FGESx7eiQ@mail.gmail.com>
Subject: Re: [PATCH 3/5] powerpc: dts: klondike: Add UART nodes
From: Josh Boyer <jwboyer@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Tanmay Inamdar <tinamdar@apm.com>, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 11:57 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon,  2 Apr 2012 12:09:05 +0530, Tanmay Inamdar <tinamdar@apm.com> wrote:
>> Adding UART nodes in Klondike device tree file.
>>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>> :100644 100644 4ff2852... d5bf2e1... M        arch/powerpc/boot/dts/klondike.dts
>>  arch/powerpc/boot/dts/klondike.dts |   24 ++++++++++++++++++++++++
>>  1 files changed, 24 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/powerpc/boot/dts/klondike.dts b/arch/powerpc/boot/dts/klondike.dts
>> index 4ff2852..d5bf2e1 100644
>> --- a/arch/powerpc/boot/dts/klondike.dts
>> +++ b/arch/powerpc/boot/dts/klondike.dts
>> @@ -222,6 +222,30 @@
>>                               #size-cells = <1>;
>>                               ranges;
>>                               clock-frequency = <0>;
>> +
>> +                             UART0: serial@50001000 {
>> +                                    device_type = "serial";
>> +                                    compatible = "ns16550";
>> +                                    reg = <0x50001000 0x00000100>;
>> +                                    virtual-reg = <0x50001000>;
>
> Why do you need virtual-reg?  The kernel should handle all iomapping
> properly without this.

Right.  It's been used for platforms that actually use the
zImage/treeImage wrapper for printf support, but this uses u-boot as
far as I know.  It shouldn't need it.

josh
