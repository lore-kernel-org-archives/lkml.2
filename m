Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab2EaRzX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:55:23 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:4236 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab2EaRzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:55:21 -0400
From: Krystian Garbaciak <Krystian.Garbaciak@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: RE: [PATCH 2/4] regmap: Make internal read/write functions
 reentrant from themselves.
Thread-Topic: [PATCH 2/4] regmap: Make internal read/write functions
 reentrant from themselves.
Thread-Index: AQHNP0wbjaM9xxTzTEOa4TqLvwvC55bkKbxw
Date: Thu, 31 May 2012 17:49:44 +0000
Message-ID: <751C305CD2876B4990194D0512DE8BF2441CA8B6@SW-EX-MBX01.diasemi.com>
References: <201205311616.q4VGGZjR014516@sw-eng-lt-dc-vm2>
 <20120531164033.GJ2666@opensource.wolfsonmicro.com>
In-Reply-To: <20120531164033.GJ2666@opensource.wolfsonmicro.com>
Accept-Language: pl-PL, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The internal reading functions need no modification for current
> > implementation of indirect access.
> 
> So the subject should really be "Make internal write functions reentrant"?

Yes, it can be.

> We can't safely do this for all buses, some want to DMA and you can't DMA
> from stack.  This also means that we'll no longer be able to send a single buffer
> to the device as we'll never have the value immediately following the register
> address and padding any more.  That'll increase overhead on many systems, you
> can often see the handover on gathers on a scope.
> 
> I don't understand why we can't take the decision to write the page register
> before we start using the buffer?

I will try to solve this on next patch revision.

> Also, it seems like your mailing setup is a bit broken - these messages aren't
> being threaded with each other.

I've sent it like a bunch of new patches with different numbering, if that might be the reason.
Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, 
some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it
is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, 
copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.

Please consider the environment before printing this e-mail
