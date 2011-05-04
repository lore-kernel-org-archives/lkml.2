Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784Ab1EDR2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:28:39 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23290 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab1EDR2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ddo6JquNa06TGkvKEDWwzMogfPPZFQiJ5Q2wjg2hQ7i7EX4sB3Jb29LkOdv6wiVFos
         bgurmG0DeWL9yeJKvfvg==
Date: Wed, 4 May 2011 10:28:36 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Michal Hocko <mhocko@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] mm: get rid of CONFIG_STACK_GROWSUP ||
 CONFIG_IA64
In-Reply-To: <20110504083005.GA1375@tiehlicka.suse.cz>
Message-ID: <alpine.LSU.2.00.1105041016110.23159@sister.anvils>
References: <20110503141044.GA25351@tiehlicka.suse.cz> <alpine.LSU.2.00.1105031142260.7349@sister.anvils> <20110504083005.GA1375@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Michal Hocko wrote:
> 
> This case is obscure enough already because we are using VM_GROWSUP to
> declare expand_stack_upwards in include/linux/mm.h

Ah yes, I didn't notice that it was already done that way there
(closer to the definitions of VM_GROWSUP so not as bad).

> while definition is guarded by CONFIG_STACK_GROWSUP||CONFIG_IA64. 
> What the patch does is just "make it consistent" thing. I think we
> should at least use CONFIG_STACK_GROWSUP||CONFIG_IA64 at both places if
> you do not like VM_GROWSUP misuse.

If it's worth changing anything, yes, that would be better.

> 
> > Not a nack: others may well disagree with me.
> > 
> > And, though I didn't find time to comment on your later "symmetrical"
> > patch before it went into mmotm, I didn't see how renaming expand_downwards
> > and expand_upwards to expand_stack_downwards and expand_stack_upwards was
> > helpful either - needless change, and you end up using expand_stack_upwards
> > on something which is not (what we usually call) the stack.
> 
> OK, I see your point. expand_stack_upwards in ia64_do_page_fault can be
> confusing as well. Maybe if we stick with the original expand_upwards
> and just make expand_downwards symmetrical without renameing to
> "_stack_" like the patch does? I can rework that patch if there is an
> interest. I would like to have it symmetrical, though, because the
> original code was rather confusing.

Yes, what I suggested before was an expand_upwards, an expand_downwards
and an expand_stack (with mod to fs/exec.c to replace its call to
expand_stack_downwards by direct call to expand_downwards).

But it's always going to be somewhat confusing and asymmetrical
because of the ia64 register backing store case.

Hugh
