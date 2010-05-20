Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab0ETVsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 17:48:24 -0400
Received: from smtp-out.google.com ([74.125.121.35]:28779 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab0ETVsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 17:48:23 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=vdFnaWSAL0oiNQyiPmoUpFl63YwkTPN5mPLgpGXWOYG42F/FLXQfduYBbKI+a0Iaq
	Ajd+iuL5Ze7PX3CsLFeww==
MIME-Version: 1.0
In-Reply-To: <2767.1274270682@redhat.com>
References: <1274135154-24082-1-git-send-email-walken@google.com>
	 <1274135154-24082-3-git-send-email-walken@google.com>
	 <2767.1274270682@redhat.com>
Date: Thu, 20 May 2010 14:48:19 -0700
Message-ID: <AANLkTik5iumKs-fPG5VZS5D0mygtG-sCYeftK5SlLoIy@mail.gmail.com>
Subject: Re: [PATCH 02/10] rwsem: fully separate code pathes to wake writers 
	vs readers
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 5:04 AM, David Howells <dhowells@redhat.com> wrote:
> I hate code that jumps into braced blocks with goto.  Would it be possible for
> you to do:
>
>        readers_only:
>                if (downgrading)
>                        goto wake_readers;
>        ...
>        wake_readers:
>                /* Grant an infinite number of read locks to the readers at the front
>        ...
>
> instead, please?

Applied. Note that next patch in the series removes that code anyway :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
