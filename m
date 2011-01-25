Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab1AYHRK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 02:17:10 -0500
Received: from b.relay.invitel.net ([62.77.203.4]:42274 "EHLO
	b.relay.invitel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1AYHRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 02:17:09 -0500
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jan 2011 02:17:09 EST
Date: Tue, 25 Jan 2011 08:07:44 +0100
From: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH 4/4 v5] powerpc, video: add SM501 support for charon board.
In-reply-to: <20110125064949.GF11673@linux-sh.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-fbdev@vger.kernel.org,
        devicetree-discuss@ozlabs.org, Ben Dooks <ben@simtec.co.uk>,
        Vincent Sanders <vince@simtec.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Reply-to: hs@denx.de
Message-id: <4D3E76C0.7080306@denx.de>
Organization: DENX Software Engineering
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <1291451028-22532-2-git-send-email-hs@denx.de>
 <1295937946-26934-1-git-send-email-hs@denx.de>
 <20110125064949.GF11673@linux-sh.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

Paul Mundt wrote:
> On Tue, Jan 25, 2011 at 07:45:46AM +0100, Heiko Schocher wrote:
>> @@ -197,6 +198,15 @@
>>  			#address-cells = <1>;
>>  		};
>>  
>> +		display@1,0 {
>> +			compatible = "smi,sm501";
>> +			reg = <1 0x00000000 0x00800000
>> +			       1 0x03e00000 0x00200000>;
>> +			mode = "640x480-32@60";
>> +			interrupts = <1 1 3>;
>> +			little-endian;
>> +		};
>> +
> 
> The endian designation looks good, but it still doesn't explain why you
> have a remaining CONFIG_PPC_MPC52xx ifdef encapsulating the property
> check in the sm501fb patch. It shouldn't be needed at all. If the
> platform supports OF then the property will need to be set one way or the
> other, so there is no need for any board or CPU ifdeffery within the
> driver itself.

Argh, of course you are right, thanks! I post an update for the
"sm501fb of support" patch.

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
