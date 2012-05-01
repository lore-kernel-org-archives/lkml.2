Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab2EAXTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 19:19:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33191 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2EAXS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 19:18:58 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205011310180.7742@chino.kir.corp.google.com>
References: <1335516144-3486-1-git-send-email-minchan@kernel.org>
	<alpine.DEB.2.00.1204270323000.11866@chino.kir.corp.google.com>
	<CAPa8GCBN6U_GRaG=GYFByNB4REcVA-yy+kKMMbrGaDKULUXW9w@mail.gmail.com>
	<alpine.DEB.2.00.1205011310180.7742@chino.kir.corp.google.com>
Date: Wed, 2 May 2012 09:18:58 +1000
Message-ID: <CAPa8GCD2m9R8YWY2FhO=LOMvCHhC6T=iFdn2YmpLxjO96_B4Ew@mail.gmail.com>
Subject: Re: [RFC] vmalloc: add warning in __vmalloc
From: Nick Piggin <npiggin@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
        kosaki.motohiro@gmail.com, Neil Brown <neilb@suse.de>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Sage Weil <sage@newdream.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 May 2012 06:22, David Rientjes <rientjes@google.com> wrote:
> On Tue, 1 May 2012, Nick Piggin wrote:
>
>> > I disagree with this approach since it's going to violently spam an
>> > innocent kernel user's log with no ratelimiting and for a situation that
>> > actually may not be problematic.
>>
>> With WARN_ON_ONCE, it should be good.
>>
>
> To catch a single instance of this per-boot, sure.  I've never seen us add
> WARN_ON_ONCE()'s where we have concrete examples of kernel code that will
> trigger it, though.  Not sure why spamming the kernel log and getting
> users to think something is wrong and report the bug when it's possible to
> audit the code and make a report to the subsystem maintainer.

Because it needs to be an ongoing thing, which is caught as soon as the
developer writes some code, rather than continually audited for and fixed
up after the fact. There is not a good way to enforce this at compile time.

The existing callers do need to be fixed too, of course.
