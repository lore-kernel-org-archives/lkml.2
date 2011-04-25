Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab1DYTi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:38:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49893 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755731Ab1DYTi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110425175605.GA22289@redhat.com>
References: <20110418134421.GA15951@redhat.com> <BANLkTimO2FL3548rxa9NEoVLFbZU7mzG7g@mail.gmail.com>
 <20110418173224.GA27918@redhat.com> <BANLkTikkYapz+qiJ0skx9ykz7TT9vmTVQw@mail.gmail.com>
 <20110423175901.GA484@redhat.com> <20110423175922.GB484@redhat.com>
 <20110425113746.GM17734@mtj.dyndns.org> <20110425172644.GA20689@redhat.com>
 <BANLkTinrC1+5CVgnBCxrt895TAnLCKjTRg@mail.gmail.com> <20110425175605.GA22289@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 25 Apr 2011 12:38:04 -0700
Message-ID: <BANLkTi=JMZROehocU6dY=YBpAB69nmCrbQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] signal: sys_rt_sigtimedwait: simplify the timeout logic
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        "Nikita V. Youshchenko" <nyoushchenko@mvista.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 10:56 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> Assuming that timespec_to_jiffies() always returns nonzero if ts is
> "not zero timeout". I think it does.

You really need to double-check that it does. We've not always done
that right, and while I think "round up" is the right thing to do
there, it had better be verified and then a comment added to make sure
it doesn't change.

But yes, with verification and comment, your "if (timeout)  ..
timeout+1" would work fine.

                  Linus
