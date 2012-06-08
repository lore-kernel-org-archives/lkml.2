Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab2FHBAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 21:00:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757319Ab2FHBAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 21:00:15 -0400
Date: Thu, 7 Jun 2012 21:00:08 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: a whole bunch of crashes since todays -mm merge.
Message-ID: <20120608010008.GA7191@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
References: <20120608002451.GA821@redhat.com>
 <CA+55aFzivM8Z1Bjk3Qo2vtnQhCQ7fQ4rf_a+EXY7noXQcxL_CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzivM8Z1Bjk3Qo2vtnQhCQ7fQ4rf_a+EXY7noXQcxL_CA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 05:52:52PM -0700, Linus Torvalds wrote:
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

Hmm, I did a rebuild with a r8169 debug patch Francois sent me backed out,
and now it looks like it's fine again.

Or I might just be getting lucky..

	Dave

