Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2D1XRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 19:17:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55402 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2D1XRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 19:17:39 -0400
Message-ID: <4F9C7A8E.1020009@lwfinger.net>
Date: Sat, 28 Apr 2012 18:17:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Andreas Schwab <schwab@linux-m68k.org>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 32-bit ppc kernel
References: <4F973026.3020103@lwfinger.net>  <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>  <1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net>  <1335390257.21961.53.camel@pasglop> <4F9ABD67.3060704@lwfinger.net>  <1335565573.20866.7.camel@pasglop> <4F9B3398.9060701@lwfinger.net>  <1335573757.20866.12.camel@pasglop> <4F9C3252.7020508@lwfinger.net>  <m2y5pflnqk.fsf@igel.home> <1335653288.20866.15.camel@pasglop>
In-Reply-To: <1335653288.20866.15.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2012 05:48 PM, Benjamin Herrenschmidt wrote:
> On Sat, 2012-04-28 at 20:23 +0200, Andreas Schwab wrote:
>> Larry Finger<Larry.Finger@lwfinger.net>  writes:
>>
>>> I have done a little more debugging. The problem is definitely coming from
>>> drivers/tty/serial/pmac_zilog.c. I am getting ChanB interrupts while open,
>>> which causes the following code segment to return IRQ_NONE:
>>>
>>>         if (r3&  (CHBEXT | CHBTxIP | CHBRxIP)) {
>>>                 if (!ZS_IS_OPEN(uap_a)) {
>>
>> s/uap_a/uap_b/?
>
> Good catch... Let's see if that fixes it for Larry...

Yes, good catch by Andreas. That change does fix the problem.

Ben - Do you want to fix the typos for open/not open with the same patch?

Larry

