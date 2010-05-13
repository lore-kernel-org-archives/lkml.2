Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab0EMBMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:12:43 -0400
Received: from smtp-out.google.com ([216.239.44.51]:25542 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0EMBMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:12:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=EIpBX1oQh/SUjRaRIq41NFAI7SkNWUE5jJUaUMSlgTS/SEwDVcc0eWxvYac5q8qDY
	lwkZ8MF2Wjw53JaICh4RQ==
MIME-Version: 1.0
In-Reply-To: <1195.1273664737@redhat.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
	 <1273634462-2672-5-git-send-email-walken@google.com>
	 <1195.1273664737@redhat.com>
Date: Wed, 12 May 2010 18:12:38 -0700
Message-ID: <s2l8d20b11a1005121812s2f071c06if3907763ab0789a7@mail.gmail.com>
Subject: Re: [PATCH 04/12] rwsem: consistently use adjustment variable
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

On Wed, May 12, 2010 at 4:45 AM, David Howells <dhowells@redhat.com> wrote:
> From a human point of view, I would say keep woken, but use it to initialise
> adjustment:
>
>        adjustment = woken * RWSEM_ACTIVE_READ_BIAS;
>
> and use it to initialise 'loop':
>
>        for (loop = woken; loop > 0; loop--) {

Sounds good. I'll have it in next version.

(Arguably 'woken' might be confusing too given that we only wake the
threads later on. But I don't care much either way).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
