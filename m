Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755012Ab3ADCtp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 21:49:45 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56803 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3ADCtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 21:49:41 -0500
Date: Fri, 4 Jan 2013 02:49:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: protect against concurrent vma expansion
Message-ID: <20130104024935.GF4939@ZenIV.linux.org.uk>
References: <1354344987-28203-1-git-send-email-walken@google.com>
 <20121203150110.39c204ff.akpm@linux-foundation.org>
 <CANN689FfWVV4MyTUPKZQgQAWW9Dfdw9f0fqx98kc+USKj9g7TA@mail.gmail.com>
 <20121203164322.b967d461.akpm@linux-foundation.org>
 <20121204144820.GA13916@google.com>
 <1355968594.1415.4.camel@kernel-VirtualBox>
 <CANN689FoSGMUi0mC6dzXe5tXo-BL_4eFZ1NF-De38x8mNhPXcg@mail.gmail.com>
 <1357260005.4930.6.camel@kernel.cn.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357260005.4930.6.camel@kernel.cn.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 06:40:05PM -0600, Simon Jeons wrote:
> On Wed, 2012-12-19 at 19:01 -0800, Michel Lespinasse wrote:
> > Hi Simon,
> > 
> > On Wed, Dec 19, 2012 at 5:56 PM, Simon Jeons <simon.jeons@gmail.com> wrote:
> > > One question.
> > >
> > > I found that mainly callsite of expand_stack() is #PF, but it holds
> > > mmap_sem each time before call expand_stack(), how can hold a *shared*
> > > mmap_sem happen?
> > 
> > the #PF handler calls down_read(&mm->mmap_sem) before calling expand_stack.
> > 
> > I think I'm just confusing you with my terminology; shared lock ==
> > read lock == several readers might hold it at once (I'd say they share
> > it)
> 
> Sorry for my late response. 
> 
> Since expand_stack() will modify vma, then why hold a read lock here?

To prevent that vma being ripped out.
