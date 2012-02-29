Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab2B2UQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:16:54 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46876 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752953Ab2B2UQw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:16:52 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of amluto@gmail.com designates 10.60.4.106 as permitted sender) smtp.mail=amluto@gmail.com; dkim=pass header.i=amluto@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120229200636.GA15729@redhat.com>
References: <20120222173326.GA7139@redhat.com> <20120222173505.GD7147@redhat.com>
 <20120223154438.GA4354@redhat.com> <CA+55aFyaPY9xsDGDx0QqRR2gV_z541w_xXeQbh5Uknd26cvXCw@mail.gmail.com>
 <20120224190651.GA22287@redhat.com> <20120224190711.GB22287@redhat.com>
 <4F4E830E.3040307@mit.edu> <20120229200636.GA15729@redhat.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 29 Feb 2012 12:16:32 -0800
X-Google-Sender-Auth: Ax30l9H15tHZz3uOzt_dm71J8RE
Message-ID: <CAObL_7GdhNPNsSiTF+GfbJ3_8ud8px6=LBH173uy14y58FMivg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] epoll: introduce POLLFREE to flush ->signalfd_wqh
 before kfree()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, Roland McGrath <roland@hack.frob.com>,
        Eugene Teo <eugeneteo@kernel.sg>, Maxime Bizon <mbizon@freebox.fr>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 12:06 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 02/29, Andy Lutomirski wrote:
>>
>> On 02/24/2012 11:07 AM, Oleg Nesterov wrote:
>> > This patch adds the special event, POLLFREE, currently only for
>> > epoll. It expects that init_poll_funcptr()'ed hook should do the
>> > necessary cleanup. Perhaps it should be defined as EPOLLFREE in
>> > eventpoll.
>>
>> I have a bunch of userspace code that uses signalfd via epoll.  Does
>> this affect the ABI?
>
> I hope not ;)
>

Excellent!

To avoid further confusion, would it make sense to update the comment
in poll.h to indicate that POLLFREE is only for epoll and is internal
to the kernel?

--Andy
