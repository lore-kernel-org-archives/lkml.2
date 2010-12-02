Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab0LBSp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:45:29 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33414 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892Ab0LBSp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:45:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=KFmzL+S2P5hgMKpFIsJziV/CblyoU1PzjzY1DSkJmcc5uEAP5zf1/5MyYnkgYf3fgM
         khvBEkzuKEnw1/lfTMBpO97AJaDntqTp6smaw4LvyjG9MpumRmpi6U48rpCB920o8pU4
         IlVmhy6xcZ/xQ3vNc3PSz0eNBgrtcsKXkBEIQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTimPpEyPMVry5jyhOUe=oByp20TGJHk9s0Kz_Pqf@mail.gmail.com>
References: <4cf594e21679631af0@agluck-desktop.sc.intel.com>
	<20101201165139.a3bb2199.akpm@linux-foundation.org>
	<987664A83D2D224EAE907B061CE93D530191F27E0E@orsmsx505.amr.corp.intel.com>
	<20101202021216.2d7c33f8.akpm@linux-foundation.org>
	<AANLkTimPpEyPMVry5jyhOUe=oByp20TGJHk9s0Kz_Pqf@mail.gmail.com>
Date: Thu, 2 Dec 2010 10:45:26 -0800
Message-ID: <AANLkTinUY3f=ccaLfZB3rToxHaAKTtHK7W=zeWuGek_F@mail.gmail.com>
Subject: Re: [RFC] persistent store (version 2) (part 1 of 2)
From: Tony Luck <tony.luck@gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 2, 2010 at 8:19 AM, Tony Luck <tony.luck@intel.com> wrote:
> was being used? But even then, the user interface wouldn't change
> we could just have each device register a string to be included in
> the filename. Users could look at it if they cared, or ignore it if
> they don't care. The "type" of the data should stay at the front
> of the name so userspace can do "for f in dmesg*" to look at
> al the saved console logs, and it wouldn't matter if the files were
> "dmesg-0", "dmesg-1" or "dmesg-erst-0", "dmesg-erst-1". I
> can't quite see why anyone would care which device was used,
> but the option to provide it would be there without breaking
> apps that used the v1 interface.

Hmmm I may throw the devicename into the filename anyway ... I
still can't see why anyone would care where it came from, but doing
this would allow for consistent filenames across reboots.  My old
code just stuck sequential numbers on the end of the filenames to
make sure it didn't get collisions.  But this means that someone
might be looking at /dev/pstore/dmesg-1 when the system panics.
After the reboot they see two files: the old one and a new one. But
the old code didn't guarantee that the old one would still be "dmesg-1",
it might be "dmesg-2" and "dmesg-1" might now have the latest panic
(ordering is at the whim of the underlying storage, and if it operates in
a LIFO way this could happen).

If I name the file "dmesg-{storename}-{recordid}" then unerased
entries will get the same name next time - which may avoid some
confusion.

-Tony
