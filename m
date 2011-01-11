Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab1AKROz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 12:14:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463Ab1AKROx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 12:14:53 -0500
Message-ID: <4D2C8FF8.5060806@redhat.com>
Date: Tue, 11 Jan 2011 19:14:32 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM updates for the 2.6.38 merge window
References: <4D2ACFA7.6000502@redhat.com> <AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com> <4D2C21FE.3000406@redhat.com> <AANLkTi=_WTXYGgb3G6eWAkSpfR_=pDC=w9feKtKK8zLV@mail.gmail.com>
In-Reply-To: <AANLkTi=_WTXYGgb3G6eWAkSpfR_=pDC=w9feKtKK8zLV@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2011 06:19 PM, Linus Torvalds wrote:
> On Tue, Jan 11, 2011 at 1:25 AM, Avi Kivity<avi@redhat.com>  wrote:
>> What are your issues with the patch?
> My issues are mainly two-fold:
>
>   - I think "MINOR" is a totally idiotic and meaningless term. It has
> no technical meaning. Why would IO be special? Is it because of
> deadlock concerns with filesystem or block device layer locks? No. And
> it clearly isn't about "sleeping", since a major fault can be
> non-sleeping (think ramdisk, for example).
>
>     Look at the other FAULT_FLAG_xyzzy flags. They have _hard_
> technical reasons. There's no ambiguity. And we ALREADY HAVE the one
> that says "return if it would need to wait", and it's called
> FAULT_FLAG_ALLOW_RETRY.
>

Okay; I'll drop that patch, and look at reusing the existing infrastructure.

> The other issue is:
>
>   - I wasn't aware of this, and clearly not enough other people were
> either, or somebody would have told you that we already had people
> working on the whole FAULT_FLAG_ALLOW_RETRY thing that is much fancier
> and technically superior.
>
> So it simply boils down to the fact that I don't think
> FAULT_FLAG_MAJOR was a good idea. It's badly done, is a total and
> utter hack, and I don't see why I should ever merge it.

And I'll improve the process on core patches as well.

