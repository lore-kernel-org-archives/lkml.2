Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2CRS0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 14:26:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57192 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2CRS0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 14:26:14 -0400
MIME-Version: 1.0
In-Reply-To: <20120314185538.GB14172@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com>
 <20120311174953.GB2729@redhat.com> <CA+55aFx43nZmhRg5Qv5x-4BdgcM-y80ECrgC8mCWc0RqU+_8rQ@mail.gmail.com>
 <20120314185510.GA14172@redhat.com> <20120314185538.GB14172@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 18 Mar 2012 11:25:51 -0700
X-Google-Sender-Auth: GUV_cUejkgdJLcPsB6fUnzQDTQc
Message-ID: <CA+55aFzKc578eWYaq4+OaOM6hFjW+ePYCeC++_1p8f09YWV_hA@mail.gmail.com>
Subject: Re: [PATCH 1/1] CLONE_PARENT shouldn't allow to set ->exit_signal
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Djalal Harouni <tixxdz@opendz.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>,
        Stephen Wilson <wilsons@start.ca>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Roland McGrath <roland@hack.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 11:55 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> +       if (clone_flags & CLONE_THREAD)
> +               p->exit_signal = -1;
> +       else if (clone_flags & CLONE_PARENT)
> +               p->exit_signal = current->group_leader->exit_signal;
> +       else
> +               p->exit_signal = (clone_flags & CSIGNAL);

So why is it "current->group_leader->exit_signal" rather than the much
more logical (imho) and simpler "current->exit_signal"?

                      Linus
