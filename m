Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab1CaQWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:22:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758614Ab1CaQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=uef63-mHHgHFU14H_Rhytcyc2p34Av6Ms6n3D@mail.gmail.com>
References: <20110329040939.GA32764@redhat.com> <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com> <20110331033432.GA434@redhat.com>
 <AANLkTimPi-Vbi3DNLEeShCpfOJEuUZo3--3CQ_BMgJiS@mail.gmail.com>
 <20110331040818.GB1255@redhat.com> <AANLkTi=uef63-mHHgHFU14H_Rhytcyc2p34Av6Ms6n3D@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 Mar 2011 09:21:37 -0700
Message-ID: <AANLkTimbjYuCT0VNDM5Rk_+20LocZHYaWKU37ROv3i+G@mail.gmail.com>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 8:53 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Regardless, I'll put my money where my mouth is, and try to remove the
> crazy re-flush thing.

Yeah, that doesn't work. The tty does actually lock up when it fills
up. So clearly we actually depended on that reflushing happening.

That said, I do still think it's the right thing to do to remove that
line, it just means that I need to figure out where the missing flush
is.

                         Linus
