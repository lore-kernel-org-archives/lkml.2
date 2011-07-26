Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab1GZAoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 20:44:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49331 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GZAob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 20:44:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:from:to:cc:subject:references:date:
	in-reply-to:message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=tDI/HgK32XcxU6A2MaLaNIkc1O2mSWOgUhPtWzREfJcKDj0/9Xb+bAiSI5SXYs+xL
	sHnEInfFqWxLiyNSzB7Tg==
From: Ian Lance Taylor <iant@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, gcc-help@gcc.gnu.org,
        stufever@gmail.com, linux-kernel@vger.kernel.org,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] TRACING: Fix a copmile warning
References: <1310982010-13849-1-git-send-email-wangshaoyan.pt@taobao.com>
	<1311618747.3526.32.camel@gandalf.stny.rr.com>
	<CACqU3MVJ9Oj4pXH9O_2jnqDVBqKA+AgoWHwP-n2HGD4LU0pMHQ@mail.gmail.com>
	<1311625197.3526.35.camel@gandalf.stny.rr.com>
	<CACqU3MUKU_0FbOQT+TKLnnaoFVS_QOgzzx-tvunQy94v-eykTw@mail.gmail.com>
	<CACqU3MXO_oR+8Ac2Z7wSji0sUeu-2FwskmxZxtY9NV+XpJXuwA@mail.gmail.com>
	<1311640534.3526.50.camel@gandalf.stny.rr.com>
Date: Mon, 25 Jul 2011 17:44:25 -0700
In-Reply-To: <1311640534.3526.50.camel@gandalf.stny.rr.com> (Steven Rostedt's
	message of "Mon, 25 Jul 2011 20:35:34 -0400")
Message-ID: <mcr7h75oopi.fsf@coign.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

>> It seems gcc transforms the conditional from:
>> 
>> if (a != NULL && b != NULL) ...
>> 
>> to
>> 
>> if (b != NULL && a != NULL) ...
>> 
>> In which case the warning is fully valid. I'm not sure what's the C
>> standard guarantee in term of conditional test order. gcc 4.7.0 has
>> the same behavior.
>
> Yes it seems to be doing this :-/
>
> This is a real bug!

To be clear, gcc is not doing that, and this is not a code generation
bug.  It is a warning generation bug; the generated code is correct.

Ian
