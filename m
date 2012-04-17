Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2DQHsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:48:05 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41114 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab2DQHsC convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Tue, 17 Apr 2012 03:48:02 -0400
Message-Id: <4F8D3C4E020000780007E658@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 17 Apr 2012 08:47:58 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "David Vrabel" <david.vrabel@citrix.com>,
        "Dan Magenheimer" <dan.magenheimer@oracle.com>
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
        "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Wilk" <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>,
        "Tim (Xen.org)" <tim@xen.org>, "Sheng Yang" <sheng@yasker.org>
Subject: RE: [Xen-devel] [PATCH] xen: always set the sched clock as
 unstable
References: <1334341255-11153-1-git-send-email-david.vrabel@citrix.com>
 <4F8C1F6D020000780007E11A@nat28.tlf.novell.com>
 <4F8C33E0.2080007@citrix.com>
 <049b7b93-fb37-4962-b272-d786e1dcfacb@default>
 <4F8C4818.8070603@citrix.com>
 <8a78da52-26b2-42a2-80c7-c1ab8aee86eb@default>
In-Reply-To: <8a78da52-26b2-42a2-80c7-c1ab8aee86eb@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.04.12 at 19:30, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>>  From: David Vrabel [mailto:david.vrabel@citrix.com]
>> Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
>> 
>> On 16/04/12 17:05, Dan Magenheimer wrote:
>> >> From: David Vrabel [mailto:david.vrabel@citrix.com]
>> >> Subject: Re: [Xen-devel] [PATCH] xen: always set the sched clock as unstable
>> >
>> > Nacked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
>> 
>> Fair enough,
>> 
>> > [A stable clock] should be true for Xen 4.0+ (but not for pre-Xen-4.0).
>> 
>> The original customer problem is on a host with Xen 3.4.  What do you
>> recommend for Linux guests running such hosts?
> 
> For pre-Xen-4.0 and an unchanged PV guest, I don't know.  If you can
> back-patch the guest kernel with a workaround such as your patch, great!
> I'm only arguing against the patch getting perpetuated upstream.
>  
>> > In fact, it might be wise for a Xen-savvy kernel to check to see
>> > if it is running on Xen-4.0+ and, if so, force clocksource=tsc
>> > and tsc=reliable.
>> 
>> So, should the xen clocksource do:
>> 
>> if Xen 4.0+
>>     clock is stable, use rdtsc only.
>> else
>>     clock is unstable, use existing pvclock implementation.
> 
> Yes, that's what I propose.  To clarify:
> 
> if the guest can and does determine it is running on Xen 4.0+

_and_ TSC reads are emulated (which I don't think they are by
default).

Jan

> 	TSC is guaranteed by Xen to be stable, use clocksource=tsc tsc=reliable
> else
> 	Xen only guarantees that pvclock is stable, use pvclock


