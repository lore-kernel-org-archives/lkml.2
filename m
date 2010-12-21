Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab0LUFIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 00:08:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:53161 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab0LUFIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 00:08:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=H2GqVhZXz5EFH/Qmvu83ouz//qXTQjCKKV89sLNBak9Sz36+uWOIQANEjlFqYc6ttP
         VTjtexXwAdOiCxJrNtog==
Date: Mon, 20 Dec 2010 21:07:51 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 0/5] Change page reference hanlding semantic of page
 cache
In-Reply-To: <AANLkTikss0RW_xRrD_vVvfqy1rH+NC=WPUB2qKBaw5qo@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1012202048220.15447@tigran.mtv.corp.google.com>
References: <cover.1292604745.git.minchan.kim@gmail.com> <20101220103307.GA22986@infradead.org> <AANLkTikss0RW_xRrD_vVvfqy1rH+NC=WPUB2qKBaw5qo@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Dec 2010, Minchan Kim wrote:
> On Mon, Dec 20, 2010 at 7:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
> > You'll need to merge all patches into one, otherwise you create really
> > nasty memory leaks when bisecting between them.
> >
> 
> Okay. I will resend.
> 
> Thanks for the notice, Christoph.

Good point from hch, but I feel even more strongly: if you're going to
do this now, please rename remove_from_page_cache (delete_from_page_cache
was what I chose back when I misdid it) - you're changing an EXPORTed
function in a subtle (well, subtlish) confusing way, which could easily
waste people's time down the line, whether in not-yet-in-tree filesystems
or backports of fixes.  I'd much rather you break someone's build,
forcing them to look at what changed, than crash or leak at runtime.

If you do rename, you can keep your patch structure, introducing the
new function as a wrapper to the old at the beginning, then removing
the old function at the end.

(As you know, I do agree that it's right to decrement the reference
count at the point of removing from page cache.)

Hugh
