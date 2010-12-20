Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab0LTVJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 16:09:45 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:43086 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933068Ab0LTVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 16:09:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type;
        b=LwGyfFrAyLFpimLuGKM76vLX6LbSkEh20UfMXZRa4TQuw5l7a3mNm2P8UK7DXe417h
         fVEKVoPNpIzOnMzAgvXzRrCjVziHIc4XYw/sTL5lrEPmQ7ughoW6FGoMdqAiwMNHn4a/
         0zogs4zBrKmsGG0BWLboD0yG39iCI0g65zQ/s=
MIME-Version: 1.0
In-Reply-To: <20101220185812.GA11285@liondog.tnic>
References: <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
	<AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
	<4D0BEE1F.7020008@zytor.com>
	<AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
	<AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
	<AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
	<20101219091752.GA16150@liondog.tnic>
	<AANLkTi=9UZ5BYWo5xT=jh0upRP6PraH4S=t=tL49YRdr@mail.gmail.com>
	<20101220072632.GA28020@liondog.tnic>
	<AANLkTikhbxs-FU2qjpup17QDd67R78puMNvP4GNRwiKX@mail.gmail.com>
	<20101220185812.GA11285@liondog.tnic>
Date: Mon, 20 Dec 2010 13:09:41 -0800
X-Google-Sender-Auth: PgZGQcw2Z1moQmDlOLjsgMue5ss
Message-ID: <AANLkTim51KRmJ66OwQ=EyZia8GojhX9TMikpgAMLXRgo@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Tony Luck <tony.luck@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 10:58 AM, Borislav Petkov <bp@alien8.de> wrote:
> Yes, this was exactly what I was trying to say! Do something in a
> watchdog handler path that shows that we actually made progress. But
> you're right, we'd still need the notification. My look at "did we make
> a progress" was too simple and there _are_ nuances which need to be
> accounted for.

My view of the notification is:
1) Oops happens, gets written to persistent store.
2) fs/pstore code makes a file appear in /dev/pstore
3) Daemon that's watching /dev/pstore sees new file
4) File is read, copied some place safe and fsync'd
5) Daemon unlinks file from /dev/pstore
6) fs/pstore code tells platform level to erase record

-Tony
