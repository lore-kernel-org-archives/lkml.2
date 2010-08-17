Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386Ab0HQKMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:12:51 -0400
Received: from mx2.sophos.com ([195.166.81.53]:52358 "EHLO mx2.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000Ab0HQKMt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:12:49 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Tue, 17 Aug 2010 11:12:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008171045.26155.tvrtko.ursulin@sophos.com> <201008171201.10142.agruen@suse.de>
In-Reply-To: <201008171201.10142.agruen@suse.de>
MIME-Version: 1.0
Message-ID: <201008171112.42097.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 17/08/2010 11:12:42,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 17/08/2010 11:12:47,
	Serialize complete at 17/08/2010 11:12:47
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 Aug 2010 11:01:09 Andreas Gruenbacher wrote:
> On Tuesday 17 August 2010 11:45:25 Tvrtko Ursulin wrote:
> > Why no timeouts? It sounds like a feasible way to work around listeners
> > which have stopped working. (Timeout and -ETIME for example to be clear,
> > not allowing access).
>
> From the kernel's point of view, there is no way to guess how long those
> timeouts should be.  Watching for progress can be implemented in user space
> though.

That is why I said the timeout can be configurable. But I agree (and raise you
double :) that not only the kernel can not guess how long the timeout should
be, but the application can not know as well. One possible way to let fanotify
know that listeners is making progress is via some sort of a heartbeat
message.  Then application can set the timeout as a fail safe and perm events
can take as long as needed and we still prevent clogging the system.

How would you create a robust solution purely from userspace? With the current
interface?

> Setting errno to ETIME as a result of trying to access a file is likely to
> break some applications which are not prepared to receive this error
> condition; we cannot do that.

Why you think EPERM will be handled better?

> I'm quite sure that both of these issues have been discussed already.

Ok, I obviosuly missed it. Do you have a pointer perhaps?

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
