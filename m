Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab1CALfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 06:35:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58812 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab1CALfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 06:35:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH -v4] kbuild: Add extra gcc checks
Date: Tue, 1 Mar 2011 12:35:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org, bp@amd64.org
References: <20110221110322.GA9819@liondog.tnic> <201102282207.33489.arnd@arndb.de> <20110228213134.GA10825@liondog.tnic>
In-Reply-To: <20110228213134.GA10825@liondog.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103011235.00389.arnd@arndb.de>
X-Provags-ID: V02:K0:aLAURatUf9Rdf9hhaP9BhgfX9qCWXbnhChxMxKDFOb6
 gbM5927s0qYR3215QcDCbRmrCRvuJ+fTHF/2Yusspk8MCmPW1o
 FQTVUx6FsW4cEU68pIVqSvfLuDAb7mTx5oY9XkttJGbKKp7f95
 kCN6i7f9MdxIwfXGJj+8zt4YNp1zRfkbJPi4SY4eMgWoH3VC51
 d5DzVGYFDpFY9zZvCe+ww==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 February 2011, Borislav Petkov wrote:
> My intention was not to have multiple levels of warnings because then
> you have to go and enable the different levels and have to remember
> which level you used last, etc, etc.

I wasn't suggesting more than two, so the two would have very distinct
definitions:

W=1: Warnings that we would like to fix all over the tree, patches to
     remove these are always welcome and you can build the entire kernel
     with it. Once they are all fixed, we can make the warnings the default.

W=2: Warnings that we know we don't always want to fix, meant for what
     you describe here -- you build a single file and decide what to
     do based on common sense. 

> Instead I am thinking along with the following lines:
> 
> make W=1 [path/to/kernel/file.o] 2>w.log
> 
> and then take a look at w.log and start fixing warnings.
> 
> You can selectively ignore some of the warnings since, as you say
> yourself above, some simply make you write ugly code like enforcing
> casts just for the sake of shutting up the compiler. A great deal of the
> warnings come from includes which are hard to fix or gcc is issuing the
> warning wrong since we do sick sh*t with C in the kernel and that's OK
> :).

Yes, I understand that.

> But in all cases you have all the warnings in one single file and that's
> it. If a certain -W option is useless, we should rather remove it since
> it doesn't help anyway. The selection above is clearly not complete so
> I'd rather drop some instead of including different W=x levels.
> 
> Hmm... ?

I'd have to see the output myself. My feeling is that a lot of the
-Wextra warnings are not that useful, but I don't know which ones
are included in -Wextra these days.

	Arnd
