Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0DXSBu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 14:01:50 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46827 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab0DXSBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 14:01:48 -0400
To: ron minnich <rminnich@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Greg KH <greg@kroah.com>,
       lkml <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, rsc@swtch.com, ericvh@gmail.com,
       linux-security-module@vger.kernel.org, jt.beard@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
References: <20100421012749.GA21338@us.ibm.com>
	<20100421012908.GB24251@us.ibm.com> <20100421030406.GB10258@kroah.com>
	<20100421034532.GA9254@us.ibm.com> <m1zl0xo1m9.fsf@fess.ebiederm.org>
	<20100424033614.GA4180@us.ibm.com>
	<n2s13426df11004240925id540ed94mc2ebafada0099ec4@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 24 Apr 2010 11:01:35 -0700
In-Reply-To: <n2s13426df11004240925id540ed94mc2ebafada0099ec4@mail.gmail.com> (ron minnich's message of "Sat\, 24 Apr 2010 09\:25\:08 -0700")
Message-ID: <m11ve4wwzk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: rminnich@gmail.com, rdunlap@xenotime.net, linux-api@vger.kernel.org, eparis@redhat.com, oleg@us.ibm.com, morgan@kernel.org, akpm@linux-foundation.org, jt.beard@gmail.com, linux-security-module@vger.kernel.org, ericvh@gmail.com, rsc@swtch.com, ashwin.ganti@gmail.com, dhowells@redhat.com, linux-kernel@vger.kernel.org, greg@kroah.com, serue@us.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ron minnich <rminnich@gmail.com> writes:

> On Fri, Apr 23, 2010 at 8:36 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
>
>> An fs actually seems overkill for two write-only files for
>> process-related information.  Would these actually be candidates
>> for new /proc files?
>>
>>        /proc/grantcred - replaces /dev/caphash, for privileged
>>                tasks to tell the kernel about new setuid
>>                capabilities
>>        /proc/self/usecred - replaces /dev/capuse for unprivileged
>>                tasks to make use of a setuid capability
>
> An fs is fine.
>
> To relate this to Plan 9, where it all began, might be useful. There's
> no equivalent in Plan 9 to Linux/Unix devices of the major/minor
> number etc. variety. In-kernel drivers and out-of-kernel servers both
> end up providing the services (i.e. file name spaces) that we see in a
> Linux file system. So the Plan 9 driver for the capability device
> really does match closely in function and interface to a Linux
> kernel-based file system.
>
> Hence, making devcap a file system is entirely appropriate, because it
> best fits the way it works in Plan 9: a kernel driver that provides
> two files.
>
> It's pretty easy to write a Linux VFS anyway, so it makes sense from
> that point of view.
>
> Eric, that was a great suggestion.

A fs provides user space policy control of naming.  I.e. where the two files go.
That can also be a very big deal.  Especially when files are writable.

You have no idea how much I am frustrated by sysfs right now, because
it does not provide userspace policy control and instead mandates a
sometimes inappropriate naming convention.

Eric


