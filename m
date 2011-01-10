Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab1AJPyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:54:18 -0500
Received: from ffm.saftware.de ([83.141.3.46]:46325 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab1AJPyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:54:17 -0500
Message-ID: <4D2B2BA6.7030009@linuxtv.org>
Date: Mon, 10 Jan 2011 16:54:14 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Thomas_Schl=F6ter?= <thomas.schloeter@gmx.net>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DVB Satellite Channel Routing support for DVB-S
References: <BDD0B014-3AD5-4693-82D9-026F47A7F8A4@gmx.net> <4D2B0521.1020404@linuxtv.org> <C8296DFF-0E53-4AA2-A6ED-CA8B83D424F2@gmx.net>
In-Reply-To: <C8296DFF-0E53-4AA2-A6ED-CA8B83D424F2@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2011 04:07 PM, Thomas Schlöter wrote:
>>> I decided this should be supported by the kernel frontend code as it is impossible to send that special DiSEqC / voltage sequence from userspace.
>>
>> Why do you think that's impossible? There's a userspace implementation
>> in Enigma2.
> 
> I think the kernel implementation would be superior for two reasons:
> - There are some timing requirements regarding the 14/18V transitions and the DiSEqC message which could perform better directly from the frontend code,

Unless there's proof, I won't believe that. We're not talking about
nanoseconds, but milliseconds, and it's about setting registers of slow
I2C devices. The same timing requirements are valid for each and every
backwards compatible DiSEqC sequence, which is the most common setting.

> - In many TV recording applications there is no support for SCR and it would be harder to implement in these. For VDR, there is a patch which is difficult to configure and has some technical limitations. In MythTV and XMBC I could not find any support for SCR. Their Wiki pages or forums say, that there are no plans for Unicable support as it would take huge changes.

Many of these applications didn't or don't support DiSEqC 1.1
(uncommittted switches) or DiSEqC 1.2 (rotor commands) or USALS. Still,
we don't put this logic into the kernel to make their life easier. Don't
add unneeded complexity to the kernel.

Of course, one could decide to start a reusable library to take care of
that stuff. Honestly, I don't know whether such a library exists today.

If you find the patch was simple enough to be applied to the kernel, it
must be as simple to patch your favourite application, even in a
platform independent way (not taking into account the required changes
to the UI, which have to be done anyway).

Regards,
Andreas
