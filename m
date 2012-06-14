Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2FNI5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755028Ab2FNI5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:57:36 -0400
Message-ID: <4FD9A77A.9020502@redhat.com>
Date: Thu, 14 Jun 2012 10:57:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Zan Lynx <zlynx@acm.org>, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 1/2] msync: support syncing a small part of the file
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com> <1338497035-13014-2-git-send-email-pbonzini@redhat.com> <20120613142614.6af42ef5.akpm@linux-foundation.org> <1339624293.2080.24.camel@knife> <20120613150809.44149ef6.akpm@linux-foundation.org>
In-Reply-To: <20120613150809.44149ef6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/06/2012 00:08, Andrew Morton ha scritto:
>> > As an interested observer and a programmer who uses msync()...
>> > 
>> > I never assumed msync() did the whole file.
> OK, that's one user accounted for.  3 million to go.
> 
> Look, I'm not terribly averse to the change, but it does have this
> risk.  And it's a nasty risk because anyone who is hit by it simply
> will not know that his applcation has lost some of its data integrity.

Sure, it reminds me of the recent bug caused by using memcpy with
overlapping areas.

But really, in this case the possibility for confusion is really small,
and would entirely be the fault of the programmer.  There are argument
for addr and length, and the man page says: "To be more precise, the
part of the file that corresponds to the memory area starting at addr
and having length length is updated".  Our implementation having been
suboptimal for a long time, is not a good reason to keep it suboptimal.

Anyway yes, there is an off-by-one.

Paolo
