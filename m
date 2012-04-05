Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2DEQvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:51:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50038 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab2DEQvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:51:54 -0400
Date: Thu, 5 Apr 2012 19:51:48 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Bobby Powers <bobbypowers@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        Andi Kleen <ak@linux.intel.com>, Jeff Mahoney <jeffm@suse.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs, lockdep: get_restripe_target: use lockdep in
 BUG_ON
Message-ID: <20120405165148.GA2595@zambezi.lan>
References: <1333570774-26462-1-git-send-email-bobbypowers@gmail.com>
 <1333591452-23264-1-git-send-email-bobbypowers@gmail.com>
 <CAArOQ2Vc35VnbTCAZigTGZ3pL-f8mAtA9Ugpdjo5S=M7Ujpeiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAArOQ2Vc35VnbTCAZigTGZ3pL-f8mAtA9Ugpdjo5S=M7Ujpeiw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 12:23:01PM -0400, Bobby Powers wrote:
> On Wed, Apr 4, 2012 at 10:04 PM, Bobby Powers <bobbypowers@gmail.com> wrote:
> > spin_is_locked always returns 0 on non-SMP systems, which causes btrfs
> > to fail the mount.  There is documentation pending as to why checking
> 
> I guess I should be explicit in stating that this is a regression, so
> this patch or something else that addresses it should be pulled into
> 3.4.

Yes, this is a regression and spin_is_locked() definitely has to go.  I
don't have a strong opinion on this assert, if there are objections to
v2 I'm OK with ripping that BUG_ON entirely and replacing it with a
comment (this function and its callers are WIP).

Thanks,

		Ilya
