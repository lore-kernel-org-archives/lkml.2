Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab0J0VBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 17:01:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39665 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757079Ab0J0VBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 17:01:01 -0400
X-User-Agent: K-9 Mail for Android
References: <4CC708DE.1070000@goop.org> <1288115334.3530.7.camel@mothafucka.localdomain> <4CC8751E.40306@goop.org>
In-Reply-To: <4CC8751E.40306@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Xen-devel] Re: [PATCH] x86/pvclock-xen: zero last_value on resume
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 27 Oct 2010 13:59:54 -0700
To: Jeremy Fitzhardinge <jeremy@goop.org>, Glauber Costa <glommer@redhat.com>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        kvm-devel <kvm@vger.kernel.org>, Eelco Dolstra <e.dolstra@tudelft.nl>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Olivier Hanesse <olivier.hanesse@gmail.com>,
        Avi Kivity <avi@redhat.com>
Message-ID: <95805e88-b6d5-4ae2-9351-9e458656cfb8@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll check it this evening when I'm at a working network again :(

"Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> On 10/26/2010 10:48 AM, Glauber Costa wrote:
>> On Tue, 2010-10-26 at 09:59 -0700, Jeremy Fitzhardinge wrote:
>>> If the guest domain has been suspend/resumed or migrated, then the
>>> system clock backing the pvclock clocksource may revert to a smaller
>>> value (ie, can be non-monotonic across the migration/save-restore).
>>> Make sure we zero last_value in that case so that the domain
>>> continues to see clock updates.
>>>
>>> [ I don't know if kvm needs an analogous fix or not. ]
>> After migration, save/restore, etc, we issue an ioctl where we tell
>> the host the last clock value. That (in theory) guarantees
>monotonicity.
>>
>> I am not opposed to this patch in any way, however.
>
>Thanks.
>
>HPA, do you want to take this, or shall I send it on?
>
>Thanks,
>    J

-- 
Sent from my mobile phone.  Please pardon any lack of formatting.
