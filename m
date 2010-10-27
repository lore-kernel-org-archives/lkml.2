Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab0J0SxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 14:53:23 -0400
Received: from claw.goop.org ([74.207.240.146]:41817 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab0J0SxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 14:53:21 -0400
Message-ID: <4CC8751E.40306@goop.org>
Date: Wed, 27 Oct 2010 11:53:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        kvm-devel <kvm@vger.kernel.org>, Eelco Dolstra <e.dolstra@tudelft.nl>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Olivier Hanesse <olivier.hanesse@gmail.com>,
        Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH] x86/pvclock-xen: zero last_value on resume
References: <4CC708DE.1070000@goop.org> <1288115334.3530.7.camel@mothafucka.localdomain>
In-Reply-To: <1288115334.3530.7.camel@mothafucka.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/26/2010 10:48 AM, Glauber Costa wrote:
> On Tue, 2010-10-26 at 09:59 -0700, Jeremy Fitzhardinge wrote:
>> If the guest domain has been suspend/resumed or migrated, then the
>> system clock backing the pvclock clocksource may revert to a smaller
>> value (ie, can be non-monotonic across the migration/save-restore).
>> Make sure we zero last_value in that case so that the domain
>> continues to see clock updates.
>>
>> [ I don't know if kvm needs an analogous fix or not. ]
> After migration, save/restore, etc, we issue an ioctl where we tell
> the host the last clock value. That (in theory) guarantees monotonicity.
>
> I am not opposed to this patch in any way, however.

Thanks.

HPA, do you want to take this, or shall I send it on?

Thanks,
    J
