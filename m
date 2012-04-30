Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab2D3J5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 05:57:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35353 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab2D3J5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 05:57:34 -0400
X-Sasl-enc: M/bMvkdXmXq8Mq+M5YD0nBg8FStj96t1BTboqIvGG9Py 1335779852
Message-ID: <4F9E61FC.8070409@ladisch.de>
Date: Mon, 30 Apr 2012 11:57:16 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
CC: Josh Boyer <jwboyer@gmail.com>, Borislav Petkov <borislav.petkov@amd.com>,
        andymatei@gmail.com, "Huang, Shane" <Shane.Huang@amd.com>,
        Borislav Petkov <bp@amd64.org>, linux-kernel@vger.kernel.org
Subject: Re: Unhandled IRQs on AMD E-450
References: <fa.CZQqvHf3CBfYWzhSDPNOWxTTD9w@ifi.uio.no>	<fa.Vmg5vDod2/oKvwyy9BcalhoT+Lo@ifi.uio.no>	<14969994.2790.1335342903511.JavaMail.geo-discussion-forums@vbbfr18>	<4F97BA60.4080505@ladisch.de>	<20120427082203.GB9233@aftab.osrc.amd.com>	<CAPRPZsCHAOvemogn7mWnWfykhANeEx5K=OG9Xt+veDjEWOiDYA@mail.gmail.com>	<CA+5PVA6e-JaS809t9=4=SoxX4cFEYfxxb9-KAXk68ENGg6Kw8w@mail.gmail.com>	<CAPRPZsDDEYUf2a+=ZbwvFw+qJku0UvMLf0+eNDvw+FbinCbysA@mail.gmail.com>	<CA+5PVA4NJ4fB-qEVB45sz48E7kCdwZ+O5D9jvk16z4hrXSgCwQ@mail.gmail.com> <CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com>
In-Reply-To: <CAPRPZsB=axM88+fGkghbh3qxDv=vRQtfrKqT0e59EZPrrS0V+A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Van den Keybus wrote:
> - Detect stuck interrupts after a number (5) of consecutive unhandled
> IRQs within a specified time frame (100ms).

Why 5?  This threshold is likely to be too low; fast consecutive interrupts
can easily happen more often with a very busy device, while an actual stuck
interrupt will call the handler in an endless loop and very quickly result
in many thousands of calls.

> --- linux-3.2.16.orig/include/linux/irqdesc.h	2012-04-23
> 00:31:32.000000000 +0200

Your mailer wraps lines; see Documentation/email-clients.txt.


Regards,
Clemens
