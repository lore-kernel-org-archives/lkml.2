Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab1C1D7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 23:59:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109Ab1C1D7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 23:59:18 -0400
MIME-Version: 1.0
In-Reply-To: <1301284006-18808-1-git-send-email-amwang@redhat.com>
References: <20110327175203.GA15862@fibrous.localdomain> <1301284006-18808-1-git-send-email-amwang@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 27 Mar 2011 20:58:10 -0700
Message-ID: <AANLkTi=mqKF=xeMYbj9LZgPfSLHSkO1JRXsNTW3LyHqu@mail.gmail.com>
Subject: Re: [Patch] proc: check error pointer returned by m_start()
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric B Munson <emunson@mgebm.net>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 8:46 PM, Amerigo Wang <amwang@redhat.com> wrote:
>
> This is true, that commit changed the return value of m_start(),
> which will return an error pointer on failure, but Al forgot
> to check the error pointer in m_stop() which will be called
> when m_start() fails. This patches fixes it.

I did this slightly differently, and put the check in m_stop()
instead, because I felt that matched the logic of m_start, while
vma_stop() is more of an internal helper thing.

I dunno. I don't think it matters. But one thing I reacted to was that
when I was walking through the logic, I really wanted to say "seq_file
is wrong to call m_stop if m_start returned an error code". I really
felt like "hwy, if ->start fails, we damn well shouldn't have called
->stop".

But I guess we're stuck with that particular semantic for seq_files by now.

                         Linus
