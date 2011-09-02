Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1IBSqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:46:19 -0400
Received: from smtp-out.google.com ([216.239.44.51]:14436 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754734Ab1IBSqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:46:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=aC88XQZ/W7vc0UQh/Oa7+7LxDqbof0i5CdvI1nxelqjxNjfnypcS6DnwZfmSaBvSn
	4ZZEPA6bV4IunYBH8ynkw==
MIME-Version: 1.0
In-Reply-To: <8a788f3fbf2ad1316e462bf5aae623bab9d38319.1314922370.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314922370.git.jeremy.fitzhardinge@citrix.com>
	<8a788f3fbf2ad1316e462bf5aae623bab9d38319.1314922370.git.jeremy.fitzhardinge@citrix.com>
Date: Fri, 2 Sep 2011 11:46:08 -0700
Message-ID: <CAG7+5M0s76O_TWBaoY2KU+WeEoJYEhkLLDXfg81WHYNvavH3yw@mail.gmail.com>
Subject: Re: [PATCH 06/13] x86/ticketlock: add slowpath logic
From: Eric Northup <digitaleric@google.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 1, 2011 at 5:54 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> Maintain a flag in both LSBs of the ticket lock which indicates whether
> anyone is in the lock slowpath and may need kicking when the current
> holder unlocks.  The flags are set when the first locker enters
> the slowpath, and cleared when unlocking to an empty queue.

Are there actually two flags maintained?  I only see the one in the
ticket tail getting set/cleared/tested.
