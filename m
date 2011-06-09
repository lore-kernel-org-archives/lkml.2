Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab1FIDjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 23:39:08 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:64914 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab1FIDjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 23:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=cUqa+qxN1fDY0L6K/1UmJ0b0ncxbXsf4M02qwKMBH2pfWYup+VxsppWv/q4dzwjgqP
         7nnjWQwAZqGUgIwLdbUu1w9a43TZ0Fo/C0Slx0896OLCkYCy1VrjrN15tzav3f9sVyhB
         BhdTOJxdx8gJR9cwvBlp+JXSivLMhvJwj9/Ok=
MIME-Version: 1.0
In-Reply-To: <4DF037C6.4000507@linux.intel.com>
References: <20110609004435.14550.qmail@science.horizon.com> <4DF037C6.4000507@linux.intel.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 8 Jun 2011 23:38:45 -0400
X-Google-Sender-Auth: vPXpg4Ef96gGbZ1a7MI7UURFqQg
Message-ID: <BANLkTik62dLMf5PCPGeW=9P=sF2QcnW42g@mail.gmail.com>
Subject: Re: Change in functionality of futex() system call.
To: Darren Hart <dvhart@linux.intel.com>
Cc: George Spelvin <linux@horizon.com>, david@rgmadvisors.com,
        kyle@moffetthome.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 11:02 PM, Darren Hart <dvhart@linux.intel.com> wrote:
> On 06/08/2011 05:44 PM, George Spelvin wrote:
>> I'm not sure if it's best, but the risk of RO waiters interfering could
>> be solved by giving them a lower prioirty for wakeup and always waking
>> RW-mapped waiters first.
>
> This strikes me as bending over backwards and jumping through hoops
> inside the kernel to avoid having to do proper permissions management in
> userspace.

Huh?

I still don't understand why userspace ought to need to deny read
access to a file to prevent DoS.  I think it's entirely reasonable for
userspace to make the assumption that users with read access cannot
make changes visible to writers unless explicitly documented (i.e.
file locking, which is so thoroughly broken that it shouldn't be taken
as an example of how to design anything).

Given that current kernels make this use safe and the proposal is to
make it unsafe, I think it's worth designing the interface to avoid
introducing new security problems.

--Andy
