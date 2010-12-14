Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760230Ab0LNXWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:22:41 -0500
Received: from smtp-out.google.com ([74.125.121.35]:55605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0LNXWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=OuB9Cp19s6pcASeD43+5jO+p6t15xw4HFRIPdkdo1NL5rYZnCPYoRVf2a85io1Tlw3
         a3vLiFZE6Rvn+ZTeUs9Q==
MIME-Version: 1.0
In-Reply-To: <AANLkTim-sV6JO5apPdd9oG23q3THaZ1FazfF1nqUfs6C@mail.gmail.com>
References: <1291335412-16231-1-git-send-email-walken@google.com>
	<1291335412-16231-2-git-send-email-walken@google.com>
	<20101208152740.ac449c3d.akpm@linux-foundation.org>
	<AANLkTikYZi0=c+yM1p8H18u+9WVbsQXjAinUWyNt7x+t@mail.gmail.com>
	<AANLkTinY0pcTcd+OxPLyvsJgHgh=cTaB1-8VbEA2tstb@mail.gmail.com>
	<20101214005140.GA29904@google.com>
	<20101213170526.3b010058.akpm@linux-foundation.org>
	<AANLkTim-sV6JO5apPdd9oG23q3THaZ1FazfF1nqUfs6C@mail.gmail.com>
Date: Tue, 14 Dec 2010 15:22:35 -0800
Message-ID: <AANLkTim-CBKeXYiK=TWHafcEto32mKAqCggTVW5-r9nj@mail.gmail.com>
Subject: Re: [PATCH 1/6] mlock: only hold mmap_sem in shared mode when
 faulting in pages
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 7:43 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Without _any_ at all of the crappy "rwsem_contended()" or the stupid
> constants, we hold it only for reading, _and_ we drop it for any
> actual IO. So the semaphore is held only for actual CPU intensive
> cases. We're talking a reduction from minutes to milliseconds.

It's actually still several seconds for a large enough mlock from page cache.

But yes, I agree it'll do fine for now :)

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
