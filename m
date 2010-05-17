Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0EQXNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 19:13:41 -0400
Received: from smtp-out.google.com ([74.125.121.35]:39186 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0EQXNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 19:13:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=EcPup6DS/N52GBI5dBdw5oEtFvm5af0X9xJwqyskaQRIbDsLp65idI3cvBa07Jimn
	yNjoWY9xf6fw7ukPP+8dA==
Date: Mon, 17 May 2010 16:13:31 -0700
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Subject: Re: [PATCH 07/10] generic rwsem: implement down_read_critical() /
	up_read_critical()
Message-ID: <20100517231331.GA30847@google.com>
References: <1274135154-24082-1-git-send-email-walken@google.com> <1274135154-24082-8-git-send-email-walken@google.com> <alpine.LFD.2.00.1005171532430.4195@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005171532430.4195@i5.linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 03:44:24PM -0700, Linus Torvalds wrote:
> You didn't update the comment for the new name here...
> 
> > - when the rwsem is write owned, down_read_unfair() callers get queued in
> >   front of threads trying to acquire the rwsem by other means.
> 
> .. or here. In this case, it really is more about "unfairness", but I'm 
> not convinced it should be so in the naming anyway, even if internally it 
> might be __down_read_unfair. "critical" I think covers both.

Gah! Sorry for missing the comment updates. I agree with you on the naming,
I just didn't remember about the comment.

Will send identical patch with the correct comment as reply to this.

> Anyway, the series looks mostly acceptable to me in this form. I think it 
> conceptually works out, and I think that the non-preemption guarantee 
> should mean that starvation of writers is not likely an issue. However, 
> I'd definitely like some second opinions on it. I'm not going to apply 
> this series without acks from people. So you should try to convince DavidH 
> too that this actually really does matter and makes sense.

I'll see what I can do here. Thanks !

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
