Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2E3Ond (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 10:43:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38925 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab2E3Ona (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 10:43:30 -0400
Message-ID: <4FC631F0.9080109@zytor.com>
Date: Wed, 30 May 2012 07:42:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Andre Przywara <andre.przywara@amd.com>, Jacob Shin <Jacob.Shin@amd.com>,
        mingo@elte.hu, jeremy@goop.org, tglx@linutronix.de,
        xen-devel@lists.xensource.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] x86/amd: fix crash as Xen Dom0 on AMD Trinity
 systems
References: <1338383402-3838-1-git-send-email-andre.przywara@amd.com> <4FC63DAF0200007800086DC5@nat28.tlf.novell.com> <4FC62888.9010407@amd.com> <4FC649790200007800086E51@nat28.tlf.novell.com>
In-Reply-To: <4FC649790200007800086E51@nat28.tlf.novell.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 07:23 AM, Jan Beulich wrote:
> 
> I see - the Xen code blindly overwrites pv_cpu_ops, despite not
> having initialized all members. That's an obvious oversight of the
> patch that introduced the _regs variants.
> 
> Plus having secondary instances of things like rdmsrl_amd_safe()
> in asm/paravirt.h seems pretty strange an approach (which was
> why initially I didn't spot how a crash could happen there) - only
> the lowest level functions should get re-implemented here.
> 

This kinds of things are part of why Xen makes me want to cry regularly.

	-hpa

