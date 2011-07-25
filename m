Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab1GYPFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 11:05:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350Ab1GYPFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 11:05:36 -0400
Message-ID: <4E2D862C.10204@redhat.com>
Date: Mon, 25 Jul 2011 18:05:16 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Alexander Graf <agraf@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jan Kiszka <jan.kiszka@web.de>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, gorcunov@gmail.com,
        levinsasha928@gmail.com, asias.hejun@gmail.com,
        prasadjoshi124@gmail.com
Subject: Re: [GIT PULL] Native Linux KVM tool for 3.1
References: <alpine.DEB.2.00.1107242335580.18045@tiger> <4E2CA6DE.4040900@web.de> <CAOJsxLEkXpDCiMZZnSXnxQ6-PFBwMEv4j5mLRhPZVMKw=LoPSQ@mail.gmail.com> <20110725075305.GA32294@elte.hu> <0EAA5203-D598-4CBA-B8D2-AB371A7689A9@suse.de> <CAOJsxLFv74GaBpNkVSWpEpqs505smUb2yBrMAh7UY_ggVWPwFA@mail.gmail.com> <ECCD7C67-C339-43EA-8A57-513173899813@suse.de> <4E2D2AE8.7050100@redhat.com> <20110725131022.GJ24072@8bytes.org>
In-Reply-To: <20110725131022.GJ24072@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2011 04:10 PM, Joerg Roedel wrote:
> >  That actually makes a ton of sense.  One immediate win would be that
> >  klibc can be tuned to the kernel it ships with (the dynamic loader will
> >  pick the correct object), so less #ifdef trees.  Another would be to
> >  make klibc the formal kernel interface, which allows us to reimplement
> >  an older interface in terms of the one that supercedes it.
>
> A libc in the kernel tree would indeed make a lot of sense and I am all
> for it :) It would also help to get new interfaces to the users faster.
> But it should probably not be the primary exported interface. This would
> just move the compatability problem from the kernel into user-space.

It's a better place for it, IMO.  For example, if we dump xnotify in 
favour of ynotify, we can implement xnotify using ynotify in klibc, and 
so avoid increasing the kernel's footprint.  As another example, there's 
an OS that implements its 32-bit ABI in userspace.

(of course that only works for new interfaces; the old ones have to be 
implemented in the kernel unless we thunk them somehow)

-- 
error compiling committee.c: too many arguments to function

