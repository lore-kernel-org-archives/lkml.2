Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347Ab2C3Tq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 15:46:56 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35299 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756919Ab2C3Tqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 15:46:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120330161500.GA32247@mail.hallyn.com>
References: <20120328075549.GA2204@moon>
	<20120328081639.GB2286@moon>
	<20120328194312.GA22211@mail.hallyn.com>
	<20120328194613.GA3678@redhat.com>
	<20120328213044.GA26190@peqn>
	<20120328213736.GM2204@moon>
	<20120329023053.GA10187@mail.hallyn.com>
	<20120330123122.GB2024@moon>
	<20120330141219.GC3693@sergelap>
	<20120330144035.GC2024@moon>
	<20120330161500.GA32247@mail.hallyn.com>
Date: Fri, 30 Mar 2012 12:46:51 -0700
X-Google-Sender-Auth: FnHOawqKhYLLq91WAmWPFBaz_9I
Message-ID: <CAGXu5jKjjvVUKeRM0_RQx7T-r74-v9PofPYUoGJYg1xmWcc2dQ@mail.gmail.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
From: Kees Cook <keescook@chromium.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 9:15 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Cyrill Gorcunov (gorcunov@openvz.org):
>> On Fri, Mar 30, 2012 at 09:12:19AM -0500, Serge Hallyn wrote:
>> ...
>> > >
>> > > Yes, I wanna take a look on Eric's set first just to get right
>> > > "picture" of everything. And I wanted to find a minimal solution
>> > > with current kernel code base which could be extended in future.
>> > >
>> > > That said I guess the current init-ns-only approach should do the
>> > > trick for a while. And (thanks for pointing) I need to add a test
>> > > if a caller which tries to obtain uids has enought credentials
>> > > for that (probably CAP_FOWNER), right?
>> >
>> > Sorry, I'm not sure which caller you mean.  Neither f_setown nor
>> > f_getown require privilege right now.  Oh, you mean at restart?
>>
>> I meant the dumper. Yes, at moment f_get/setown requires no privileges
>> but I'm not sure if uid/euid is same or less sensible information
>> than pid, that's why I though CAP_FOWNER might be worth to add, no?
>
> Hmm, I would say no, but that might be a good question for kees.
>
> IMO it's not sensitive information and so no sense requiring privilege
> (and encouraging handing out of extra privilage to get at the info)

Nothing jumps out at me about just seeing uid/euid. Everything can be
construed as an information leak, but this don't seem like something
that needs special protection.

-Kees

-- 
Kees Cook
ChromeOS Security
