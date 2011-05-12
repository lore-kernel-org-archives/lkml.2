Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab1ELWPz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:15:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:38646 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932786Ab1ELWPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:15:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=oCrchYcdCLBZGi8OwEIdaMPZjBBcyC6MA/wOFm3Sg9D2hLoWbpY/VkdcNdKJ492RHP
         o4ztjV6LcFUI9G0d7Kmw==
MIME-Version: 1.0
In-Reply-To: <20110512220715.GA7451@redhat.com>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
	<BANLkTi==OatTqfDbnAmHQA0t2DmokEd-CA@mail.gmail.com>
	<BANLkTik7wQc05OQTHThBbrFhKx2pM1Tx+A@mail.gmail.com>
	<BANLkTimjHiaZ+b03FLb1LX=ycv=cAVyJZw@mail.gmail.com>
	<20110512213542.GB17596@elte.hu>
	<BANLkTikPmq=NOt-9t0odVVnrRshM=MsnJw@mail.gmail.com>
	<20110512215023.GA20939@elte.hu>
	<20110512220715.GA7451@redhat.com>
Date: Fri, 13 May 2011 00:15:41 +0200
Message-ID: <BANLkTi=EfPMQ4Z7+_SrKAeOYHfDC6t9vyQ@mail.gmail.com>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
From: Stephane Eranian <eranian@google.com>
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 12:07 AM, Dave Jones <davej@redhat.com> wrote:
> On Thu, May 12, 2011 at 11:50:23PM +0200, Ingo Molnar wrote:
>
>  > Dunno, i would not couple them necessarily - certain users might still have
>  > access to kernel symbols via some other channel - for example the System.map.
>
> That always made this security by obscurity feature seem pointless for the bulk
> of users to me. Given the majority are going to be running distro kernels,
> anyone can find those addresses easily no matter how hard we hide them on the
> running system.

> Unless we were somehow introduced randomness into where we unpack the kernel
> each boot, and using System.map as a table of offsets instead of absolute addresses.
>
Good point about System.map! Even if /proc/kallsyms contains zero
addresses, I can
still get them from /boot/System.map which is readable by everyone, I
think. It does
not contain the modules addresses, but you have the core functions, unless I am
somehow mistaken.
