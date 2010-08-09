Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab0HIHeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 03:34:18 -0400
Received: from smtp-out.google.com ([74.125.121.35]:12488 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab0HIHeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:34:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=odNJcWTbsQYSXwv5Ljc9F2yZOPHcWWS8VgE1z/bfoa5CrBX9xRE/ZBJ+tlw2S79vo
	Vz8biodwIIGB+IebU5hqQ==
MIME-Version: 1.0
In-Reply-To: <20100809072618.GB1586@ucw.cz>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100804195704.GA23681@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008050616340.25170@asgard.lang.hm>
	<20100809072618.GB1586@ucw.cz>
Date: Mon, 9 Aug 2010 00:34:12 -0700
Message-ID: <AANLkTikd6SvRH_u5hhEfqKRbYnwVpU0PN-NSUEtGyiA9@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take two
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: david@lang.hm, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, florian@mickler.org,
        rjw@sisk.pl, stern@rowland.harvard.edu, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk, menage@google.com,
        david-b@pacbell.net, James.Bottomley@suse.de, tytso@mit.edu,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 12:26 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
>> >I should have asked this earlier...  What exactly are the apps'
>> >compatibility constraints?  Source-level APIs?  Byte-code class-library
>> >invocations?  C/C++ dynamic linking?  C/C++ static linking (in other
>> >words, syscall)?
>>
>> For Java/Dalvik apps, the wakelock API is pertty high level -- it
>> talks to a service via RPC (Binder) that actually interacts with the
>> kernel.  Changing the basic kernel<->userspace interface (within
>
> Strange. Arve claimed that open/close is too slow, and few
> microseconds faster ioctl is needed, and now we learn it actually uses
> RPC.

For the high level Java API, yes.  For lower level userspace code,
like the code that processes keypresses, the kernel interface is used
directly.  I think an open/close per keypress would be a bit
excessive, for example.  In any case, that ignores the fact that it's
useful to have statistics, which are tricky to maintain meaningfully
if you destroy the handle after use every time (by closing the fd).

Brian
