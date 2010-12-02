Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679Ab0LBQTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 11:19:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51639 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab0LBQTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 11:19:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=t9LF1GS/LM1VgP7enfXtBScjlxZipJC9WZwROQ7DgvzqtKE1Hn7yqd3B+i6bgGIEhD
         Ey+y1t72bjSgxtxCwStiKdD0NCJNzxR2Z5l5ZcrM3RxDGJ5scJNhdPrC7lNsXeAkVVm7
         SCh7bJTBT/aGRzxPY9mj4CmfazOdTaYEXQAPc=
MIME-Version: 1.0
In-Reply-To: <20101202021216.2d7c33f8.akpm@linux-foundation.org>
References: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
	<20101201165139.a3bb2199.akpm@linux-foundation.org>
	<987664A83D2D224EAE907B061CE93D530191F27E0E@orsmsx505.amr.corp.intel.com>
	<20101202021216.2d7c33f8.akpm@linux-foundation.org>
Date: Thu, 2 Dec 2010 08:19:18 -0800
X-Google-Sender-Auth: f9t0JHlldQ_4BPO_hjt3j7h1Qvg
Message-ID: <AANLkTimPpEyPMVry5jyhOUe=oByp20TGJHk9s0Kz_Pqf@mail.gmail.com>
Subject: Re: [RFC] persistent store (version 2) (part 1 of 2)
From: Tony Luck <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>, "greg@kroah.com" <greg@kroah.com>,
        "Huang, Ying" <ying.huang@intel.com>, Borislav Petkov <bp@alien8.de>,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 2:12 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> One thing which does leap out of the v2 implementation is the hardwired
> assumption that there is one store kernel-wide.  I suppose that's OK as
> a version-1 implementation detail thing, but we should avoid hardwiring
> that assumption into the presentation of v1's userspace interfaces.

I think that user space should be able to survive the change to
multiple storage devices.  We can just read all the records from
all the devices and present each one as a file. We just need to
remember where they came from so we cal call the right erase
function when the user unlinks the file.  Unless there is some
reason why we'd want to make it visible to the user which storage
was being used? But even then, the user interface wouldn't change
we could just have each device register a string to be included in
the filename. Users could look at it if they cared, or ignore it if
they don't care. The "type" of the data should stay at the front
of the name so userspace can do "for f in dmesg*" to look at
al the saved console logs, and it wouldn't matter if the files were
"dmesg-0", "dmesg-1" or "dmesg-erst-0", "dmesg-erst-1". I
can't quite see why anyone would care which device was used,
but the option to provide it would be there without breaking
apps that used the v1 interface.

The tricky part of multiple devices is the write side ... how to
decide which records should be stored in which device. I can
imagine lots of possibilities (store by type, round-robin, use
one until full then move on, look at the size of the data to be
stored and save in the device with the smallest record size
that could hold the data, ...) but I'm just making stuff up - I
don't know how someone with two or more devices would
actually want to assign them ... hence I'm leaving this as
an exercise to someone with more than one device :-)

-Tony
