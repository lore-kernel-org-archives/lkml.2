Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab1ANWbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:31:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:60452 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1ANWbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:31:51 -0500
Message-ID: <4D30CE56.2030704@kernel.org>
Date: Fri, 14 Jan 2011 14:29:42 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Christoph Lameter <cl@linux.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] x86: set percpu cpu0 lpj to default
References: <4D2F7AE9.2000809@kernel.org> <20110113224450.GA14918@kroah.com> <alpine.LFD.2.00.1101132349590.2678@localhost6.localdomain6> <4D2F84FC.7000804@kernel.org> <20110113234852.GB17904@kroah.com> <4D2F9948.8000804@kernel.org> <20110114004428.GA26847@kroah.com> <4D2FA305.2030808@kernel.org> <alpine.DEB.2.00.1101140846560.2423@router.home> <4D30BE98.7060809@kernel.org> <20110114221616.GA17959@kroah.com>
In-Reply-To: <20110114221616.GA17959@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2011 02:16 PM, Greg KH wrote:
> On Fri, Jan 14, 2011 at 01:22:32PM -0800, Yinghai Lu wrote:
>>
>> We need to use udelay() in early stage.
> 
> I still don't agree with this.
> 
> Again, _please_ post your real patches that require this, after
> explaining exactly _why_ this is needed at all, and what real problem it
> is solving.
> 
> You seem to be totally ignoring this request I've made numerous times,
> which isn't appreciated at all.  So I'm guessing that we should also
> ignore your patches as well?

Please forget about those patches about disabling USB legacy early now.

the one is because 

echi debug port early serial console in drivers/usb/early/ehci-dbgp.c

is using udelay() in early stage.

and now udelay is relying to use loops_per_jiffy in per cpu area that not set yet.

Yinghai
