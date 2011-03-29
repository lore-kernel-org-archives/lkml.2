Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab1C2E1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 00:27:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab1C2E13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 00:27:29 -0400
Date: Tue, 29 Mar 2011 00:26:53 -0400
From: Dave Jones <davej@redhat.com>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: vma corruption in today's -git
Message-ID: <20110329042652.GA570@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	=?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTinOQ1yXqJJVo=k9YSM=xG2Fg2GSAE8z2O3dGsME@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinOQ1yXqJJVo=k9YSM=xG2Fg2GSAE8z2O3dGsME@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 12:19:01PM +0800, Américo Wang wrote:
 > On Tue, Mar 29, 2011 at 12:09 PM, Dave Jones <davej@redhat.com> wrote:
 > > Running a kernel that I built from a git pull from this afternoon,
 > > I ran a barrage of stress tests, including some of the new syscall fuzzing
 > > work that I've been working on.  Everything seemed just fine, except that
 > > after I had stopped running everything, loadavg was still at 6, with
 > > top showing kworker processes running at high % of cpu.
 > >
 > > I ran perf top, and got this ..
 > >
 > >  BUG: unable to handle kernel paging request at fffffffffffffff3
 > >  IP: [<ffffffff8118d3e9>] vma_stop.clone.3+0x18/0x33
 > 
 > Should be fixed by:
 > 
 > commit 76597cd31470fa130784c78fadb4dab2e624a723
 > Author: Linus Torvalds <torvalds@linux-foundation.org>
 > Date:   Sun Mar 27 19:09:29 2011 -0700
 > 
 >     proc: fix oops on invalid /proc/<pid>/maps access

excellent, thanks. I'll repull and try again.

	Dave

