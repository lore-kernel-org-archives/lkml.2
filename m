Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036Ab2HOSUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:20:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab2HOSUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:20:39 -0400
Date: Wed, 15 Aug 2012 20:17:11 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
Message-ID: <20120815181711.GA19018@redhat.com>
References: <20120726134748.GA20605@localhost> <CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com> <20120810015222.GA19286@localhost> <CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com> <20120815030110.GA24836@localhost> <CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com> <20120815130159.GA3221@redhat.com> <1345041021.31459.88.camel@twins> <20120815175651.GA17814@redhat.com> <CAGXu5jJ+HOdSxS7Ec=TW06h6KEpEmi-rF+Jk8L5LiQsp9gyAtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ+HOdSxS7Ec=TW06h6KEpEmi-rF+Jk8L5LiQsp9gyAtg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, Kees Cook wrote:
>
> It sounds like get_task_comm shouldn't have locking at all then? It
> should just do a length-limited copy

Without task_lock() get_task_comm() can copy incomplete new name.

Honestly, I do not know any user which "strictly" needs the correct
name. may be proc.

> and make sure there is a trailing
> 0-byte?

get_task_comm()->strncpy() should always see (and copy) 0-byte.
comm[TASK_COMM_LEN - 1] == '\0' and this byte is never changed.

set_task_comm()->strlcpy() can write to this byte, but it can
only write 0 again.

Or I am totally confused ;)

Oleg.

