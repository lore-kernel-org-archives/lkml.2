Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935Ab2CIO5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 09:57:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab2CIO5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 09:57:48 -0500
Date: Fri, 9 Mar 2012 09:57:14 -0500
From: Dave Jones <davej@redhat.com>
To: Yang Bai <hamo.by@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>
Subject: Re: inode->i_wb_list corruption.
Message-ID: <20120309145713.GA21543@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Yang Bai <hamo.by@gmail.com>, Jan Kara <jack@suse.cz>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	viro@zeniv.linux.org.uk, Christoph Hellwig <hch@infradead.org>
References: <20120306185137.GA15881@redhat.com>
 <20120306210307.GC8781@quack.suse.cz>
 <20120307072608.GA24087@localhost>
 <20120307104240.GB18658@quack.suse.cz>
 <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO_0yfNt2jgiTPZn5NkwBAjQZtk+377gG71d6QOuXQrDHjdkEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 04:34:57PM +0800, Yang Bai wrote:
 
 > I still want to know how to reproduce this bug. I add the following
 > patch to the kernel fc-16 3.2.9-1
 > 
 > So on every inode_wb_list_del, it will show the whole list.
 > 
 > and Doing while true; do touch a && rm -f a; done for almost one day
 > without any problem.
 > 
 > So How to reproduce it??

If it was that easy, I'd be bisecting it by now ;-)

This, like a bunch of other really weird bugs that we have no explanation for,
only seems to be being hit by a small minority of users.

One common thing seems to be that they were all quad core intel
boxes, with i915 graphics.

We have some reports of i915 causing memory corruption after suspend/hibernate,
but none of these reports mention whether they've done that (I just asked).

	Dave

