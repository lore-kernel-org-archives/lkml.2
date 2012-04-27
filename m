Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761241Ab2D0TJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:09:12 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:44854 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759592Ab2D0TJK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:09:10 -0400
Date: Fri, 27 Apr 2012 15:08:49 -0400 (EDT)
Message-Id: <20120427.150849.187285510481819228.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: mjt@tls.msk.ru, linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        raven@themaw.net, thomas@m3y3r.de, stable@kernel.org
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFwvFaxBT8Mdp5s4-6Gxy7nM4WVzbWna4RF_OUK3hnx+jQ@mail.gmail.com>
References: <CA+55aFwud1nXRr+HpzH8rSkEWcZ_rJmoE7UtQt76D=A3qcb6GQ@mail.gmail.com>
	<20120427.143402.1028957981042061092.davem@davemloft.net>
	<CA+55aFwvFaxBT8Mdp5s4-6Gxy7nM4WVzbWna4RF_OUK3hnx+jQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 27 Apr 2012 12:08:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 11:42:58 -0700

> On Fri, Apr 27, 2012 at 11:34 AM, David Miller <davem@davemloft.net> wrote:
>>
>> If systemd wants to use version 5 of this thing, it has to have the
>> same workaround code automountd has.  It is systemd (and now the
>> kernel) which is broken.
> 
> There's no question that systemd is broken.
> 
> But those broken binaries are out in the wild. End of story.

And my point is that automountd was out there longer, and encoded
the "broken" structure size into the resulting binaries.

>> We should have never touched version 5 of the data-structure.  Having
>> 5 years of workaround precedence in userspace proves this.
> 
> Umm. The thing is, those broken binaries *work* on 32-bit.  They were
> *tested* on 32-bit. They were *shipped* on 32-bit.

As were the automount binaries.

systemd coded to an interface which did not exist in reality, and if
they had used the automountd sources as a reference (the only other
user of this interface) they would have seen this.

Look, I can almost guarantee that whoever wrote the automountd
workaround code looked at this situation and said "yeah, it's
impossible to get this right in the kernel for all cases for v5, so
let's just do it where we _can_ be absolutely certain and that's here
in this userland routine doing the autofs stuff"

And you know what, whoever that guy was, he was right.
