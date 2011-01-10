Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab1AJR3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:29:50 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:54632 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754540Ab1AJR3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 12:29:47 -0500
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX199FQBYPHR9ufh+dy/La9sBptqW86b4JBzWzeqrk+
	kmBTfCziSBOsxc
From: Oliver Endriss <o.endriss@gmx.de>
Reply-To: linux-media@vger.kernel.org
Organization: ESCAPE GmbH EDV-Loesungen
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] DVB Satellite Channel Routing support for DVB-S
Date: Mon, 10 Jan 2011 18:28:39 +0100
User-Agent: KMail/1.9.6
Cc: Thomas =?iso-8859-1?q?Schl=F6ter?= <thomas.schloeter@gmx.net>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <BDD0B014-3AD5-4693-82D9-026F47A7F8A4@gmx.net> <C8296DFF-0E53-4AA2-A6ED-CA8B83D424F2@gmx.net> <4D2B2BA6.7030009@linuxtv.org>
In-Reply-To: <4D2B2BA6.7030009@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201101101828.40752@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 January 2011 16:54:14 Andreas Oberritter wrote:
> On 01/10/2011 04:07 PM, Thomas Schlöter wrote:
> >>> I decided this should be supported by the kernel frontend code as it is impossible to send that special DiSEqC / voltage sequence from userspace.
> >>
> >> Why do you think that's impossible? There's a userspace implementation
> >> in Enigma2.
> > 
> > I think the kernel implementation would be superior for two reasons:
> > - There are some timing requirements regarding the 14/18V transitions and the DiSEqC message which could perform better directly from the frontend code,
> 
> Unless there's proof, I won't believe that. We're not talking about
> nanoseconds, but milliseconds, and it's about setting registers of slow
> I2C devices. The same timing requirements are valid for each and every
> backwards compatible DiSEqC sequence, which is the most common setting.
> 
> > - In many TV recording applications there is no support for SCR and it would be harder to implement in these. For VDR, there is a patch which is difficult to configure and has some technical limitations. In MythTV and XMBC I could not find any support for SCR. Their Wiki pages or forums say, that there are no plans for Unicable support as it would take huge changes.
> 
> Many of these applications didn't or don't support DiSEqC 1.1
> (uncommittted switches) or DiSEqC 1.2 (rotor commands) or USALS. Still,
> we don't put this logic into the kernel to make their life easier. Don't
> add unneeded complexity to the kernel.
> 
> Of course, one could decide to start a reusable library to take care of
> that stuff. Honestly, I don't know whether such a library exists today.
> 
> If you find the patch was simple enough to be applied to the kernel, it
> must be as simple to patch your favourite application, even in a
> platform independent way (not taking into account the required changes
> to the UI, which have to be done anyway).

Ack, this stuff should be implemented as a userspace library.
(Btw, there is an experimental unicable patch for VDR.)

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
4 MByte Mod: http://www.escape-edv.de/endriss/dvb-mem-mod/
Full-TS Mod: http://www.escape-edv.de/endriss/dvb-full-ts-mod/
----------------------------------------------------------------
