Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2BBThI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:37:08 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:24945 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757016Ab2BBThG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:37:06 -0500
Date: Thu, 2 Feb 2012 14:37:02 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] MCE, AMD: Select SMP explicitly
Message-ID: <20120202193702.GA9502@elliptictech.com>
References: <1328209817-18913-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328209817-18913-1-git-send-email-bp@alien8.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 2012-02-02 20:10 +0100, Borislav Petkov wrote:
> Randy Dunlap reported that building randconfigs which do not select
> CONFIG_SMP cause the following link error:
> 
> mce_amd.c:(.cpuinit.text+0x4723): undefined reference to `cpu_llc_shared_map'
> 
> Fix it.
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> Link: http://lkml.kernel.org/r/4F298A6C.6010101@xenotime.net
> Signed-off-by: Borislav Petkov <bp@alien8.de>
[...]
>  config X86_MCE_AMD
>  	def_bool y
>  	prompt "AMD MCE features"
> -	depends on X86_MCE && X86_LOCAL_APIC
> +	depends on X86_MCE && X86_LOCAL_APIC && SMP

Is this feature truly irrelevant on UP systems?  I ask because I've
always enabled this option on my UP AMD systems in the past...

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

