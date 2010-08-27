Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab0H0SMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 14:12:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0H0SMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 14:12:33 -0400
Date: Fri, 27 Aug 2010 14:12:05 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Karel Zak <kzak@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] VFS: Sanity check mount flags passed to change_mnt_propagation()
Message-ID: <20100827181205.GD26872@shell>
References: <20100826200318.GA13636@shell> <20100827011436.GB3521@parisc-linux.org> <20100827174313.GA26872@shell> <AANLkTik-uXDtvA9G7sr1becN235PMzFWmuD5t9Xu4yZX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik-uXDtvA9G7sr1becN235PMzFWmuD5t9Xu4yZX@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
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

Yes, thanks!

I'll run the test program again before resubmitting. :)

-VAL
