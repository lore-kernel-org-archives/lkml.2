Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab0LQXx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 18:53:57 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45650 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045Ab0LQXx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 18:53:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YwJdKW/I2GNyUemibbHKP/jQvvz5fI5m9J9JMeyG26p9/BgTIED2XQ3DUQnW/KC8CZ
         5d5n1bVj9WSoc4Cu90Vh+JhjNb6Ptg/P7xXrMhQYZIZwNSu+YveZYnBuRUUQ+i9YJS0B
         hIbnPo/5ybpOvmi/wGbqMOVTO7BI0/0oGxtC8=
MIME-Version: 1.0
In-Reply-To: <4D0BEE1F.7020008@zytor.com>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	<AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
	<AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
	<AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
	<AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
	<AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
	<4D0BEE1F.7020008@zytor.com>
Date: Fri, 17 Dec 2010 15:53:55 -0800
X-Google-Sender-Auth: C1yc8Xz6kvKLWe4l0xjq0MZcSVg
Message-ID: <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
From: Tony Luck <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 17, 2010 at 3:11 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> There are two models I can think of:
>
> 1. a file where the head is automatically dropped as space requires.
> 2. a filesystem where the oldest files are automatically reclaimed.
>
> 1 has been implemented in actual systems, 2 is kind of a logical extension.

#2 sounds more applicable here (we have some multi-kilobyte
blobs of data, one from each kmsg_dumper invocation - and
it would seem useful to keep them as separate entities)

I'm not sure whether everyone would be happy with this. Imagine you
have a system that gets two OOPs, followed by a full panic - but that
the persistent store only has space for two of the three reports. I think
that most people would want the first OOPs and the panic ... i.e.
drop the middle bit, rather than the oldest bit.

-Tony
