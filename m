Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab2B1Hng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 02:43:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49985 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab2B1Hnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 02:43:35 -0500
Date: Mon, 27 Feb 2012 23:44:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] consolidate WARN_...ONCE() static variables
Message-Id: <20120227234451.3a00a76a.akpm@linux-foundation.org>
In-Reply-To: <4F4C93520200007800075197@nat28.tlf.novell.com>
References: <4F4BAAFA0200007800074F8F@nat28.tlf.novell.com>
	<20120227160302.ef9f6af4.akpm@linux-foundation.org>
	<4F4C93520200007800075197@nat28.tlf.novell.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 07:41:54 +0000 "Jan Beulich" <JBeulich@suse.com> wrote:

> >>> On 28.02.12 at 01:03, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Mon, 27 Feb 2012 15:10:34 +0000
> > "Jan Beulich" <JBeulich@suse.com> wrote:
> > 
> >> Due to the alignment of following variables, these typically consume
> >> more than just the single byte that 'bool' requires, and as there are
> >> a few hundred instances, the cache pollution (not so much the waste of
> >> memory) sums up. Put these variables into their own section, outside
> >> of any half way frequently used memory range.
> >> 
> >> v2: Do the same also to the __warned variable of rcu_lockdep_assert().
> >> (Don't, however, include the ones used by printk_once() and alike, as
> >> they can potentially be hot.)
> > 
> > I have a bad feeling that I still don't understand this patch.  Ho hum.
> > 
> > What are the rules for the new .data.unlikely section?  When should
> > people put variables into this section?  Perhaps we can document this
> > somewhere?
> 
> If I knew the "where" part of this, I could put together a few sentences.
> I just grep-ed through Documentation/, without finding e.g. any rules
> or guidelines for using {,un}likely()...
>

At the definition site in vmlinux.lds?
