Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab2BWWqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 17:46:16 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53978 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755023Ab2BWWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 17:46:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.107.68 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120223223348.GA25513@elte.hu>
References: <4F43F9F0.4000605@zytor.com> <20120221202019.GB2381@redhat.com>
 <1329856745.25686.72.camel@gandalf.stny.rr.com> <20120222073251.GB17291@elte.hu>
 <20120222075334.GA25053@elte.hu> <7479958c-1932-4ced-a7a4-53ac6ea3a38e@email.android.com>
 <20120222081855.GB25318@elte.hu> <20120222213343.GA19758@bloggs.ozlabs.ibm.com>
 <20120223100205.GD24310@elte.hu> <CA+55aFwwV3GsqHue8oUsx-XbvSQXSawJ0w5z=wL8ue=EH4ifzw@mail.gmail.com>
 <20120223223348.GA25513@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 14:45:53 -0800
X-Google-Sender-Auth: sNUGi33fYhD4Fz67p2d7_n8beps
Message-ID: <CA+55aFyc+C4YjfMvS5EKrL1JD4oMBLM58Zn+FfcWevNZO9vSKA@mail.gmail.com>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups + docs
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        a.p.zijlstra@chello.nl, mathieu.desnoyers@efficios.com,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 2:33 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> At the risk of being flamed some more, where does the confusion
> stem from?

>From the fact that "very" is an English word that means "very", and
"unlikely()" and "likely()" are already used in their obvious meaning.

So quite frankly, "very_unlikely()" quite naturally means something
else than you are trying to make it mean.

The fact that EVERY SINGLE OTHER OPERATION that worked on that data
structure used to be named "jump_label_xyz()" and is  now named
"static_key_xyz()" is also a big clue, I think. Naming it anything
else was always a mistake.

Seriously, I don't understand why you don't just use the obvious name.
The data structure is named "static_key". The things that change it
are named "static_key_inc()" or something. So a name like
"static_key_true()" is simply *better*, isn't it?

It's not just about less confusion, it's actually about just having
consistent naming.

                         Linus
