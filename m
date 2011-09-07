Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab1IGQad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:30:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599Ab1IGQa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:30:28 -0400
Message-ID: <4E678992.5050709@redhat.com>
Date: Wed, 07 Sep 2011 18:11:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Marcelo Tosatti <mtosatti@redhat.com>,
        KVM <kvm@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH 08/13] xen/pvticketlock: disable interrupts while blocking
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com> <38bb37e15f6e5056d5238adac945bc1837a996ec.1314922370.git.jeremy.fitzhardinge@citrix.com> <1314974826.1861.1.camel@twins> <4E612EA1.20007@goop.org> <1314996468.8255.0.camel@twins> <4E614FBD.2030509@goop.org> <20110906151408.GA7459@redhat.com> <4E66615E.8070806@goop.org> <20110906182758.GR5795@redhat.com> <4E66EF86.9070200@redhat.com> <20110907134411.GV5795@redhat.com>
In-Reply-To: <20110907134411.GV5795@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2011 04:44 PM, Don Zickus wrote:
> >
> >  Is there a way to tell whether an NMI was internally or externally
> >  generated?
> >
> >  I don't think so, especially as two or more NMIs can be coalesced.
> >  So any NMI received on this first cpu has to check the NMI reason
> >  port?
>
> Well we cheat and execute all the nmi handlers first.  If they come back
> as handled, we skip the check for the external NMI.

And hope that no other NMI was generated while we're handling this one.  
It's a little... fragile?

> But you are right, other than checking the reason port, there isn't a way
> to determine if an NMI is internally or externally generated.

Ouch.

>
> >
> >  >>
> >  >>   But on the other hand, I don't really care if you can say that this path
> >  >>   will never be called in a virtual machine.
> >  >
> >  >Does virtual machines support hot remove of cpus?  Probably not
> >  >considering bare-metal barely supports it.
> >  >
> >
> >  They do.
>
> But vcpus probably don't have the notion of a bsp cpu, so perhaps virtual
> machines can get away with it easier?  (I don't know enough about the hot
> cpu remove code to really explain it, just enough to know it can cause
> problems and people are trying to address it).
>

The concept of a bsp exists in exactly the same way as on real hardware.

-- 
error compiling committee.c: too many arguments to function

