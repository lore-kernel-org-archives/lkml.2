Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1G0Pph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:45:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab1G0Ppe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:45:34 -0400
Message-ID: <4E30327C.5020509@redhat.com>
Date: Wed, 27 Jul 2011 18:45:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, "Przywara, Andre" <Andre.Przywara@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
References: <4E2F0068.1080001@redhat.com> <20110726181304.GD32536@aftab> <4E2F0498.8050005@zytor.com> <20110726183721.GF32536@aftab> <4E2F09BB.9060605@zytor.com> <4E2F1889.8030708@amd.com> <4E2F90A2.4030409@redhat.com> <20110727062120.GA5272@aftab> <20110727065932.GA16555@elte.hu> <4E2FDAD0.8000809@redhat.com> <20110727153731.GA19477@aftab>
In-Reply-To: <20110727153731.GA19477@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 06:37 PM, Borislav Petkov wrote:
> On Wed, Jul 27, 2011 at 05:30:56AM -0400, Avi Kivity wrote:
> >  On 07/27/2011 09:59 AM, Ingo Molnar wrote:
> >  >  >
> >  >  >   Yeah, actually the idea is to patch the kernel only this one time
> >  >  >   and never ever be needing to do this for future CPUs, for this
> >  >  >   matter.
> >  >
> >  >  But the check you have added turns this workaround on for all family
> >  >  0x15 CPUs. If a family 0x15 CPU is built with a larger or more
> >  >  associative cache, one that does not need the workaround, we would
> >  >  still turn on the workaround.
> >
> >  Similarly, if family 0x21 CPUs have a similar arrangement (with
> >  identical or different cache sizes and associativity) the hardcoded
> >  check will fail.
>
> So, in short, I$ design is the same for all F15h processors so a family
> 0x15 check suffices here.

What about F21h processors?  I see you're not checking them.

Is there any reason the check should not be made based on topology?

-- 
error compiling committee.c: too many arguments to function

