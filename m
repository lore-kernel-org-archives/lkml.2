Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0H1K5K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 06:57:10 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:33483 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0H1K5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 06:57:09 -0400
Date: Sat, 28 Aug 2010 04:57:07 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Bob Copeland <me@bobcopeland.com>
Cc: Valerie Aurora <vaurora@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Karel Zak <kzak@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Sanity check mount flags passed to
	change_mnt_propagation()
Message-ID: <20100828105707.GD3521@parisc-linux.org>
References: <20100826200318.GA13636@shell> <20100827011436.GB3521@parisc-linux.org> <20100827174313.GA26872@shell> <AANLkTik-uXDtvA9G7sr1becN235PMzFWmuD5t9Xu4yZX@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik-uXDtvA9G7sr1becN235PMzFWmuD5t9Xu4yZX@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 01:51:06PM -0400, Bob Copeland wrote:
> On Fri, Aug 27, 2010 at 1:43 PM, Valerie Aurora <vaurora@redhat.com> wrote:
> > On Thu, Aug 26, 2010 at 07:14:36PM -0600, Matthew Wilcox wrote:
> >> Hrm. ?I think we can do this a bit more pithily.
> >>
> >> ? ? ? /* Only one propagation flag should be set, and no others */
> >> ? ? ? if (hweight32(type) != 1 &&
> >> ? ? ? ? ? (type & ~(MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
> >> ? ? ? ? ? ? ? return 0;
> >>
> >> Too clever?
> >
> > I was hoping someone would go find the best bitop for me, thanks. :)
> > hweight32() is an awkward name but the comment makes it clear. ?I'm
> > happy with either.
> >
> > Thanks for the help,
> 
> Didn't read surrounding code, but is that supposed to be '||'?
> 
> Otherwise the case where only a single non-propagation flag is
> set no longer returns 0...

Val's original code returned 0 as failure.  So a single non-propagation
flag set shouldn't return 0.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
