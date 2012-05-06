Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407Ab2EFICO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 04:02:14 -0400
Received: from antcom.de ([188.40.178.216]:44735 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2EFICL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 04:02:11 -0400
Message-ID: <4FA62FFE.6090301@antcom.de>
Date: Sun, 06 May 2012 10:02:06 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM Open Source Research and Development
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.3) Gecko/20120329 Icedove/10.0.3
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        w.sang@pengutronix.de, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND] Documentation: devicetree: Fix value format description
References: <1336217886-27224-1-git-send-email-stigge@antcom.de> <4FA57504.2070308@landley.net>
In-Reply-To: <4FA57504.2070308@landley.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/05/12 20:44, Rob Landley wrote:
> On 05/05/2012 06:38 AM, Roland Stigge wrote:
>> Numeric values in dts files can be specified in decimal and hex (the latter
>> prefixed 0x). The current documentation is updated with this patch to prevent
>> confusion about what is meant with values without "0x" (previously hex, now
>> dec).
> 
> This updates the documentation to consistently say 0x in front of hex
> values, but doesn't change the device tree _parser_. What did the parser
> previously do with this input?

I can add the following para to the patch description if you ack:

===========================================================================
Background:

Since 2011's update to scripts/dtc/dtc-lexer.l, we only support the
/dts-v1/ format which mandates "0x" for hex values. Practically,
literals (<V1>[0-9]+|0[xX][0-9a-fA-F]+ -> DT_LITERAL) are handled via
strtoull() with base==0 ("auto"), while we previously also had a
DT_LEGACYLITERAL (<INITIAL>[0-9a-fA-F]+), forcing base==16. Not anymore.
===========================================================================

Thanks in advance,

Roland
