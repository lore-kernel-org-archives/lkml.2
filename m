Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab2FHBEf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:04:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55596 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab2FHBEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:04:34 -0400
Date: Thu, 7 Jun 2012 18:05:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: a whole bunch of crashes since todays -mm merge.
Message-Id: <20120607180515.4afffc89.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFzivM8Z1Bjk3Qo2vtnQhCQ7fQ4rf_a+EXY7noXQcxL_CA@mail.gmail.com>
References: <20120608002451.GA821@redhat.com>
	<CA+55aFzivM8Z1Bjk3Qo2vtnQhCQ7fQ4rf_a+EXY7noXQcxL_CA@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jun 2012 17:52:52 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Jun 7, 2012 at 5:24 PM, Dave Jones <davej@redhat.com> wrote:
> > I just started seeing crashes while doing simple things, like logging on a console..
> 
> I'm looking at it right now, and the sync_mm_rss() patch is pure
> garbage. In many ways.
> 
> You can't do sync_mm_rss() from mmdrop(), because there's no reason to
> believe that the task that does mmdrop() does it on its own active_mm.
> And even if you *could* do it there, it's still horribly wrong,
> because it does it at the end *after* it already freed the mm!
> 
> Does it go away if you revert that (commit 40af1bbdca47). I wish I
> hadn't merged it, or that I had noticed how horrible it was before I
> pushed out.
> 

It appears this is due to me fat-fingering conflict resolution last
week.  That hunk is supposed to be in mm_release(), not mmput().    

It's probably best to throw the patch away for now - we'll try again.
