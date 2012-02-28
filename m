Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2B1ADI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 19:03:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756269Ab2B1ADD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 19:03:03 -0500
Date: Mon, 27 Feb 2012 16:03:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jan Beulich" <JBeulich@suse.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] consolidate WARN_...ONCE() static variables
Message-Id: <20120227160302.ef9f6af4.akpm@linux-foundation.org>
In-Reply-To: <4F4BAAFA0200007800074F8F@nat28.tlf.novell.com>
References: <4F4BAAFA0200007800074F8F@nat28.tlf.novell.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012 15:10:34 +0000
"Jan Beulich" <JBeulich@suse.com> wrote:

> Due to the alignment of following variables, these typically consume
> more than just the single byte that 'bool' requires, and as there are
> a few hundred instances, the cache pollution (not so much the waste of
> memory) sums up. Put these variables into their own section, outside
> of any half way frequently used memory range.
> 
> v2: Do the same also to the __warned variable of rcu_lockdep_assert().
> (Don't, however, include the ones used by printk_once() and alike, as
> they can potentially be hot.)

I have a bad feeling that I still don't understand this patch.  Ho hum.

What are the rules for the new .data.unlikely section?  When should
people put variables into this section?  Perhaps we can document this
somewhere?


