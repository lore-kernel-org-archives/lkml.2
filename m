Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728Ab2CRVYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 17:24:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab2CRVYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 17:24:48 -0400
Date: Sun, 18 Mar 2012 17:24:44 -0400
From: Dave Jones <davej@redhat.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.3-rc7] sys_poll use after free (hibernate)
Message-ID: <20120318212443.GA7312@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	richard -rw- weinberger <richard.weinberger@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20120313005855.GA24639@redhat.com>
 <CAFLxGvxXBp1+D3Az7onYYvvi9S=_pPLSFpHqOCurjYwTpxbB6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvxXBp1+D3Az7onYYvvi9S=_pPLSFpHqOCurjYwTpxbB6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 08:47:19PM +0100, richard -rw- weinberger wrote:
 > On Tue, Mar 13, 2012 at 1:58 AM, Dave Jones <davej@redhat.com> wrote:
 > > While trying to reproduce the i915 memory corruption problem with hibernate,
 > 
 > If you cannot reproduce the problem you can send me debug/test-patches.
 > I have two machines where I can reproduce the issue within an hour.

At the time I was hoping to bisect it. But it looks like it only happens on
ironlake era graphics and newer, which I don't have.

With that info, I'm not sure it's really bisectable. The bug has probably
been there since day 1 when ironlake support was added.
See the thread 'Subject: Re: inode->i_wb_list corruption.' for some further
thoughts, where it's theorised that the GTT contains stale entries after
when we thaw.  I wouldn't be surprised if no-one had even tried hibernate
(or at least noticed the memory corruption immediately) before that was merged.

My thinking is that some kind of GTT teardown in the ->hibernate routine is
probably what's needed.

	Dave

