Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2DFRUg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 13:20:36 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42468 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab2DFRUe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 13:20:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120405165148.GA2595@zambezi.lan>
References: <1333570774-26462-1-git-send-email-bobbypowers@gmail.com>
	<1333591452-23264-1-git-send-email-bobbypowers@gmail.com>
	<CAArOQ2Vc35VnbTCAZigTGZ3pL-f8mAtA9Ugpdjo5S=M7Ujpeiw@mail.gmail.com>
	<20120405165148.GA2595@zambezi.lan>
Date: Fri, 6 Apr 2012 12:20:33 -0500
Message-ID: <CAKcLGm86PNyGZStE79Jg9nWygiCaz=fOt6uvOaMA57gnOYo6MA@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs, lockdep: get_restripe_target: use lockdep in BUG_ON
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Bobby Powers <bobbypowers@gmail.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>, Andi Kleen <ak@linux.intel.com>,
        Jeff Mahoney <jeffm@suse.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 5, 2012 at 11:51 AM, Ilya Dryomov <idryomov@gmail.com> wrote:
> On Thu, Apr 05, 2012 at 12:23:01PM -0400, Bobby Powers wrote:
>> On Wed, Apr 4, 2012 at 10:04 PM, Bobby Powers <bobbypowers@gmail.com> wrote:
>> > spin_is_locked always returns 0 on non-SMP systems, which causes btrfs
>> > to fail the mount.  There is documentation pending as to why checking
>>
>> I guess I should be explicit in stating that this is a regression, so
>> this patch or something else that addresses it should be pulled into
>> 3.4.
>
> Yes, this is a regression and spin_is_locked() definitely has to go.  I
> don't have a strong opinion on this assert, if there are objections to
> v2 I'm OK with ripping that BUG_ON entirely and replacing it with a
> comment (this function and its callers are WIP).
>

I'm still hitting this BUG_ON after applying this patch on my single
CPU AthlonXP x86 system.

I'm running a 3.3.1 kernel merged with the for-linus branch, and had
this patch applied.

I am currently testing with the BUG_ON commented out.  The btrfs
partitions mount without error, and I haven't encountered any
immediate issues.
