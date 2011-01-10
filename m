Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab1AJPHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:07:48 -0500
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:54675 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978Ab1AJPHp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:07:45 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net 6247135A6CF
Subject: Re: [PATCH] DVB Satellite Channel Routing support for DVB-S
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?Thomas_Schl=F6ter?= <thomas.schloeter@gmx.net>
In-Reply-To: <4D2B0521.1020404@linuxtv.org>
Date: Mon, 10 Jan 2011 16:07:36 +0100
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C8296DFF-0E53-4AA2-A6ED-CA8B83D424F2@gmx.net>
References: <BDD0B014-3AD5-4693-82D9-026F47A7F8A4@gmx.net> <4D2B0521.1020404@linuxtv.org>
To: Andreas Oberritter <obi@linuxtv.org>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo Andreas,

Am 10.01.2011 um 14:09 schrieb Andreas Oberritter:

> Hallo Thomas,
> 
> thank you for your contribution. However, I'm against applying it.
> 
> On 01/10/2011 05:19 AM, Thomas Schlöter wrote:
>> I have developed some modifications to the 2.6.37 DVB frontend code to support DVB satellite channel routing (aka "SCR", "Unicable", "EN50494"). Following this standard, all satellite tuners share the same cable and each of them has a fixed intermediate frequency it is supposed to tune to. Zapping is done by sending a special DiSEqC message while SEC voltage is temporarily pulled from 14 to 18 volts. This message includes the tuner's ID from 0 to 7, the frequency, band and polarisation to tune to as well as one out of two satellite positions.
>> 
>> I decided this should be supported by the kernel frontend code as it is impossible to send that special DiSEqC / voltage sequence from userspace.
> 
> Why do you think that's impossible? There's a userspace implementation
> in Enigma2.

I think the kernel implementation would be superior for two reasons:
- There are some timing requirements regarding the 14/18V transitions and the DiSEqC message which could perform better directly from the frontend code,

- In many TV recording applications there is no support for SCR and it would be harder to implement in these. For VDR, there is a patch which is difficult to configure and has some technical limitations. In MythTV and XMBC I could not find any support for SCR. Their Wiki pages or forums say, that there are no plans for Unicable support as it would take huge changes.

> 
>> Additionally, it adds fully transparent support for SCR to arbitrary applications that use the DVB API, such as MythTV, VDR, xine etc.
> 
> That statement is not true, because you have to configure Unicable LNBs,
> which you do using dvb-scr-setup.c.

Sure, you have to configure Unicable LNBs as you have to configure for example Universal LNBs. So the viewer software has to be aware of your DVB setup's parameters. If you want to have a configuration menu in the viewer software, this software only needs to send a simple ioctl message to the frontend to configure Unicable. If you want to use Unicable with viewers that do not support it, you only have to set your parameters at boot time using dvb-scr-setup.c.

That way, they are also a bit more protected against unintentional changes. In a Unicable system, all participants have interferences if there is one participant using bad settings. So if you start a DVB viewer which is badly or not yet configured, all other participants are disturbed. If you configure your Unicable system using e.g. an init-script, it is impossible to disturb anyone by starting some "Non-Unicable" software.

This can be compared to the setup of serial ports, I think. As far as I know, there is a setup utility to have the parameters set (probably at boot time), afterwards you start the actual application.

Regards,
Thomas

