Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab0FNMd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 08:33:56 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:41153 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0FNMdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 08:33:54 -0400
X-SpamScore: -29
X-BigFish: VPS-29(zz1432N1418M98dN936eM9371Pzz1202hzzz32i87h2a8h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L40887-01-EZA-02
X-M-MSG: 
Date: Mon, 14 Jun 2010 14:33:42 +0200
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] AMD errata checking framework
Message-ID: <20100614123342.GB746@escobedo.osrc.amd.com>
References: <1276262713-26864-1-git-send-email-hans.rosenfeld@amd.com>
 <4C129927.4060502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C129927.4060502@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Einsteinring_24=2C_85609_Dornach_b=2E_M=FCnchen=3B_Ges?=
	=?iso-8859-1?Q?ch=E4ftsf=FChrer=3A_Andrew_Bowd=2C_Thomas_M=2E_McCoy=2C_Gi?=
	=?iso-8859-1?Q?uliano_Meroni=3B_Sitz=3A_Dornach=2C_Gemeinde_Aschheim=2C_L?=
	=?iso-8859-1?Q?andkreis_M=FCnchen=3B_Registergericht_M=FCnchen?=
	=?iso-8859-1?Q?=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 04:14:31PM -0400, H. Peter Anvin wrote:
> On 06/11/2010 06:25 AM, Hans Rosenfeld wrote:
> > +
> > +/*
> > + * Check for the presence of an AMD erratum.
> > + * Arguments are defined in processor.h for each known erratum.
> > + */
> > +bool cpu_has_amd_erratum(const struct cpuinfo_x86 *cpu, bool osvw, ...)
> > +{
> 
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c: In
> function ?cpu_has_amd_erratum?:
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:635: error:
> expected expression before ?do?
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:636: error:
> expected expression before ?do?
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:632:
> warning: unused variable ?t?

Umpf. It seems like I underestimated the brokenness of rdmsrl() etc..
A new patch set will follow shortly. I also added va_end() calls where
necessary and replaced static_cpu_has() with cpu_has().

> Also, the use of divide and modulo when shifts and masks work are
> generally frowned upon in Linux as a matter of style.

While I agree in principle, I think that in this special case the
divide and modulo by 64 make it easier to understand what the code
does on the first look. But if you insist I will send another patch
set that replaces divide and modulo with shifts and masks.


Hans


-- 
%SYSTEM-F-ANARCHISM, The operating system has been overthrown

