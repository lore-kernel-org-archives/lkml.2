Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2DPQ3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 12:29:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:20745 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2DPQ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 12:29:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,430,1330923600"; 
   d="scan'208";a="190550051"
Message-ID: <4F8C4818.8070603@citrix.com>
Date: Mon, 16 Apr 2012 17:26:00 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, Konrad Wilk <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, Sheng Yang <sheng@yasker.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com> <4F8C1F6D020000780007E11A@nat28.tlf.novell.com> <4F8C33E0.2080007@citrix.com> <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
In-Reply-To: <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/12 17:05, Dan Magenheimer wrote:
>> From: David Vrabel [mailto:david.vrabel@citrix.com]
>> Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
> 
> Nacked-by: Dan Magenheimer <dan.magenheimer@oracle.com>

Fair enough,

> [A stable clock] should be true for Xen 4.0+ (but not for pre-Xen-4.0).

The original customer problem is on a host with Xen 3.4.  What do you
recommend for Linux guests running such hosts?

> In fact, it might be wise for a Xen-savvy kernel to check to see
> if it is running on Xen-4.0+ and, if so, force clocksource=tsc
> and tsc=reliable.

So, should the xen clocksource do:

if Xen 4.0+
    clock is stable, use rdtsc only.
else
    clock is unstable, use existing pvclock implementation.

David
