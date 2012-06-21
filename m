Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760435Ab2FUVsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 17:48:06 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:65409 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760353Ab2FUVsD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 17:48:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120621213235.GF4642@google.com>
References: <20120307162851.GC13430@redhat.com>
	<4F57AF4A.6080703@kernel.dk>
	<CAKA=qzak6N-6oHVjDozJ6KLMSWXEgzZf1xaC_1cgnoaUCyw8Ag@mail.gmail.com>
	<CAKA=qzaHJ0OcbvtT-mwKBUBvzPkxE4r-bW6gDvicKhoQeyFWEg@mail.gmail.com>
	<20120308234016.GA925@redhat.com>
	<CAKA=qzbsL9UVYLZ3=hoT-1jfp=v=_Sr=h+YeHu0qAA=Ko_7P6w@mail.gmail.com>
	<CAKA=qzbqoK5_3GXM8DZhbQ5cTU=DTg5DFFJ+46OrD7y=XrMLTg@mail.gmail.com>
	<20120621203217.GC14095@redhat.com>
	<20120621203615.GE4642@google.com>
	<CAKA=qzaFRubzvyjJQzgThRLsxLDc8NMdZy6WVZMFrF7ohsyjHw@mail.gmail.com>
	<20120621213235.GF4642@google.com>
Date: Thu, 21 Jun 2012 14:48:03 -0700
Message-ID: <CAOT6A4-H5inkkRZm2A2YpLkn=iYpn2NDGWxY3uZHRKA-y7RiWA@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Rakesh Iyer <rni@google.com>
To: Tejun Heo <tj@kernel.org>, Josh Hunt <joshhunt00@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-- Resending because my mail went out in html text and got bounced by
the list, apologies if you see it twice --

Hello,

I coded up the watchdog and dropped it in but never did get the time
to go looking for evidence of stalls so no confirmed evidence of what
the cause was.

Chad and I did manage to stare at the code long and hard and sort of
convince ourselves that cfq_cfqq_wait_busy & associated logic could be
the cause of the stall (strictly in my opinion - that logic can be
fully be fully folded into the idling logic, but that's a discussion
for another day).

Hope that helps.
-Rakesh

On Thu, Jun 21, 2012 at 2:32 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Thu, Jun 21, 2012 at 04:28:24PM -0500, Josh Hunt wrote:
> > When you say the code has diverged from upstream, do you mean from 3.0
> > to 3.5?
>
> It's based on something diverged from 2.6.X, so an ancient thing.
>
> > Or maybe I'm misunderstanding what you're getting at. Also, if
> > you have any links to the watchdog timer code you're referring to I
> > would appreciate it.
>
> Rakesh is the one who observed the bug and wrote the watchdog code.
> Rakesh, I think Josh is seeing similar cfqq hang issue.  Did the
> watchdog code reveal why that happened?  Or was it mainly to just kick
> the queue and keep it going?
>
> Thanks.
>
> --
> tejun
