Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0DOAtx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 20:49:53 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48546 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab0DOAtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 20:49:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=nYy1swymr+DTRDwMA5TlX10UxA+mbyA2MPu87d9kDh986AKChM8PV34oEP01a5nSbq
         7CzGPFXyOpgWQJ6eJ8r2vkzMIGkH70hY305BF7JnBeA5tYrQbITi5588aF7zcdMYZFOi
         /uqIZ9kaciRwQj/6exo6UnJ7zpM+4XIfcxbh4=
MIME-Version: 1.0
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 14 Apr 2010 17:49:31 -0700
Message-ID: <j2oa36005b51004141749ua63eea62m55695dd3922f882f@mail.gmail.com>
Subject: mprotect and vmas
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: aarcange@redhat.com, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quite some time there was a discussion around mprotect and why it
creates vmas.  The issue never got resolved IIRC but the urgency is
more pressing than ever.  We have today commodity machines with 8
sockets and 512G of RAM with single processes using all these
resources.

>From what I remember the idea was that an mprotect call shouldn't
really have to split a vma.  Frequent examples are DSO loading, the
malloc implementation, or thread stacks.  They both have to change the
protection of a memory region to PROT_NONE or in other cases
add/remove PROT_WRITE etc.

This information could be represented in the page table tree alone and
doesn't require a vma split.

Is this something that can be considered?  This could reduce the
number of vmas in a large process significantly, reducing the cost of
finding a specific vma or, perhaps more importantly, gaps.
