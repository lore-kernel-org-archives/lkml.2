Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965875Ab2B1RsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:48:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51297 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345Ab2B1RsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:48:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of markus@google.com designates 10.68.203.135 as permitted sender) smtp.mail=markus@google.com; dkim=pass header.i=markus@google.com
MIME-Version: 1.0
In-Reply-To: <CABqD9haZpe-i8kyHJDj4umCLyZ3E877aobabvW8_+aXeC+kTbg@mail.gmail.com>
References: <1330140111-17201-1-git-send-email-wad@chromium.org>
 <1330140111-17201-6-git-send-email-wad@chromium.org> <b983ece9dc6209269876869188303518.squirrel@webmail.greenhost.nl>
 <CABqD9haZpe-i8kyHJDj4umCLyZ3E877aobabvW8_+aXeC+kTbg@mail.gmail.com>
From: Markus Gutschke <markus@chromium.org>
Date: Tue, 28 Feb 2012 09:47:59 -0800
X-Google-Sender-Auth: x6bkn1-TGR9JJirTONSCNznvqVo
Message-ID: <CAE6n16kLOOrAV6_7_t_-PnfYoNsJ5yJfHveWykO7qQiFYKb3nQ@mail.gmail.com>
Subject: Re: [PATCH v11 06/12] seccomp: add system call filtering using BPF
To: Will Drewry <wad@chromium.org>
Cc: Indan Zupancic <indan@nul.nu>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        coreyb@linux.vnet.ibm.com, keescook@chromium.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 09:17, Will Drewry <wad@chromium.org> wrote:
> On Tue, Feb 28, 2012 at 12:51 AM, Indan Zupancic <indan@nul.nu> wrote:
>> Wouldn't it make more sense to always kill with SIGSYS, also for mode 1?
>> I suppose it's too late for that now.
>
> It would but I don't want to go and change existing ABI.

Just for the record, when this discussion came up about two years ago,
it was established that other than Chrome, there are currently no
users of Seccomp, as mode 1 is just too difficult to use for most
potential applications.

Chrome doesn't rely on the exit status of a process that violated the
seccomp restrictions, so it is highly unlikely you would break
existing userspace, if you changed the ABI. On the other hand, as mode
2 is so much more powerful than mode 1, it is unlikely that we will
see future userspace applications make use of mode 1.

In other words, changing the ABI is unlikely to cause harm, but also
unlikely to do any good. I don't have any strong opinion either way;
just providing an additional data point.


Markus
