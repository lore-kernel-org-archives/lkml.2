Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1BIQk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 11:40:58 -0500
Received: from smtp-out.google.com ([216.239.44.51]:15958 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab1BIQkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 11:40:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=cQ+6SJ5EENv0s7zravHVpsUeyj51db8WtkaAaZFdkX/9I2WG26nCapDjMguQTBBzUI
         YZNqlg8G6CNK4blH7Nyw==
MIME-Version: 1.0
Reply-To: rsc@golang.org
In-Reply-To: <1297269019.4888.91.camel@marvin>
References: <1297168678.2190.21.camel@marvin>
	<AANLkTim7YVg1BTEjyhYShgZNL3oKu+zFywC7+NgFvT3z@mail.gmail.com>
	<1297269019.4888.91.camel@marvin>
Date: Wed, 9 Feb 2011 11:40:53 -0500
X-Google-Sender-Auth: _kea62ujXUggX8eUZnqh6NSZU7c
Message-ID: <AANLkTikO2GAAe8brJKzxVUzAkZ39dReU6TcVVE909_mB@mail.gmail.com>
Subject: Re: mmap, the language go, problems with the linux kernel
From: Russ Cox <rsc@golang.org>
To: Martin Capitanio <m@capitanio.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, golang-dev <golang-dev@googlegroups.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Albert Strasheim <fullung@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think there is that much more to say but thanks for
assembling the To: line.

Go is still very much an experimental project.  It is fine
in our opinion to try things and see how they work.
We're happy to revisit design decisions if some of the
possible negatives that have been identified come to pass.

I agree with what Linus posted about it being of only very
long-term utility to change the kernel interface, and probably
not worth doing at all.  I think it's unfortunate (at least for the
people who think ulimit -v is useful for keeping your machine
from swapping) that mmap with PROT_NONE counts against
ulimit -v, but it is what it is.

In Alan's scenario about vm_overcommit, since that is a
Linux-specific feature and presumably more malleable, I would
hope that the "commit" charge doesn't happen until you do
mmap with prot != PROT_NONE.  As I said in some of the
quoted text, there are various sandboxes like Native Client
or VX32 that assume they can use mmap as a way to set up
restricted sub-address spaces at low cost, and I don't see
the benefit to committing the physical memory before the
addresses are mapped accessible.

Russ
