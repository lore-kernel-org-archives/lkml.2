Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab1EFBMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 21:12:20 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab1EFBMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 21:12:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IbX+tVnD2OVMjb8YV+ue2OGOe/vtWZoJIxgLTbr8UF7Z1dNxZCX4FOBg4JXPluEw7X
         pb/o/loXWhZY7ZDK/lEA==
MIME-Version: 1.0
In-Reply-To: <20110505063012.GA11529@tiehlicka.suse.cz>
References: <20110503141044.GA25351@tiehlicka.suse.cz>
	<alpine.LSU.2.00.1105031142260.7349@sister.anvils>
	<20110504083005.GA1375@tiehlicka.suse.cz>
	<alpine.LSU.2.00.1105041016110.23159@sister.anvils>
	<20110505063012.GA11529@tiehlicka.suse.cz>
Date: Thu, 5 May 2011 18:12:12 -0700
Message-ID: <BANLkTikGduoi8DVapz0H-uVPrrXPYF=YGg@mail.gmail.com>
Subject: Re: [PATCH resend] mm: get rid of CONFIG_STACK_GROWSUP || CONFIG_IA64
From: Hugh Dickins <hughd@google.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 11:30 PM, Michal Hocko <mhocko@suse.cz> wrote:

> So I think the flag should be used that way. If we ever going to add a
> new architecture like IA64 which uses both ways of expanding we should
> make it easier by minimizing the places which have to be examined.

If, yes.  Let's just agree to disagree.  It looks like I'm preferring
to think of the ia64 case as exceptional, and I want to be reminded of
that peculiar case; whereas you are wanting to generalize and make it
not stand out.  Both valid.

> OK, now, with the cleanup patch, we have expand_stack and
> expand_stack_{downwards,upwards}. I will repost the patch to Andrew with
> up and down cases renamed. Does it work for you?

Sounds right.

>
>> But it's always going to be somewhat confusing and asymmetrical
>> because of the ia64 register backing store case.
>
> How come? We would have expand_stack which is pretty much clear that it
> is expanding stack in the architecture specific way. And then we would
> have expand_{upwards,downward} which are clear about way how we expand
> whatever VMA, right?

Right.  I'm preferring to be reminded of the confusion and asymmetry,
you're preferring to smooth over it.

Hugh
