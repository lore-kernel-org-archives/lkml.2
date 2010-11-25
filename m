Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab0KYPR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 10:17:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55938 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0KYPR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 10:17:57 -0500
Message-ID: <4CEE7E21.3060007@redhat.com>
Date: Thu, 25 Nov 2010 17:17:53 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/9] KVM: Make the instruction emulator aware of Nested
 Virtualization
References: <1290622715-8382-1-git-send-email-joerg.roedel@amd.com> <4CED63DC.20608@redhat.com> <20101125114640.GC6031@amd.com> <20101125131351.GA9382@amd.com>
In-Reply-To: <20101125131351.GA9382@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2010 03:13 PM, Roedel, Joerg wrote:
> On Thu, Nov 25, 2010 at 12:46:40PM +0100, Roedel, Joerg wrote:
> >  We basically have two choices here:
> >
> >  	a) We expose svm internals into the emulator
> >  	b) We expose emulator internals into svm
> >
> >  Both choices are not really good from a software-design point-of-view.
> >  But I think option b) is the better one because it is easier to cope with
> >  and thus less likely to break when changing the emulator code.
>
> What we could do probably is to define the interface between the
> emulator and the architecture code in a better way. This would take the
> burden of going into architecture code for emulator changes away.

What about things like adding instructions and forgetting to add the 
corresponding svm.c code?

Of course it can happen with everything in the emulator, but at least 
there's a chance you will see the decode bits in nearby instructions.

> The current patch-set only needs a subset of the decode-cache (in the
> future probably also a subset of the fetch-cache). We could put this
> information into a seperate struct and give it to the architecture code.
>
> I planned to make the guest_mode flag a generic x86 vcpu property
> anyway, so building this structure could be limited to instructions
> emulated while the vcpu is in guest mode thus avoiding the overhead for
> the default case.
>

Good idea.  Needed for the decode bits thing as well.

-- 
error compiling committee.c: too many arguments to function

