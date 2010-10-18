Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0JRQyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 12:54:25 -0400
Received: from mga06.intel.com ([134.134.136.21]:60312 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751674Ab0JRQyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 12:54:25 -0400
MIME-Version: 1.0
In-Reply-To: <20101017185203.GD28060@infradead.org>
References: <20101016065206.GO4681@dastard>
	<20101016192027.GA6883@infradead.org>
	<1287295077.3020.83.camel@localhost.localdomain>
	<1287313332.1998.172.camel@laptop>
	<AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
	<1287323960.1998.360.camel@laptop>
	<20101017185203.GD28060@infradead.org>
Date: Mon, 18 Oct 2010 09:44:47 -0700
Message-ID: <AANLkTik0cpPvqq0YS-fFn8qs0xwPyL_PsM4g7o7eu=2J@mail.gmail.com>
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
From: Ryan Ware <ryan.r.ware@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@parisplace.org>,
        eparis@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 11:52 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Oct 17, 2010 at 03:59:20PM +0200, Peter Zijlstra wrote:
>> Well, it does suck it needs to bloat data and code when its effectively
>> disabled. Isn't there a way to gather this data before we enable it, eg.
>> scan the files list on enable or somesuch?
>>
>> I mean, if you mandate an external storage you might as well extend
>> struct inode, that's cheaper in each respect.
>
> That's in fact what it did initially.  While IBM claimed it would never
> be enabled in distros and this would be fine I feared this would not be
> true and told them to not make it have overhead if compiled in but not
> used.

Isn't it up to distros themselves to decide if this feature should be
enabled?  I bring this up because we are intending to include this
turned on by default in the MeeGo kernel for the 1.2 release next
year.

I understand there are some technical concerns regarding performance.
We should figure out how to resolve those.  That said, upstream is the
right place for this.

Ryan

> Turns out I wa right in my fear that IBM pressured distros to enable
> it anyway.  And turns out that I should have verified they didn't
> actually mess it up instead of expecting people to get such trivial
> things right.
>
>> Me, I'm henceforth making sure to have CONFIG_IMA disabled...
>
> Yeah.
>
>> >  but it doesn't
>> > help the fact that the suggested structure for storage (the radix
>> > tree) is apparently quite inefficient.  I'd love to hear other
>> > suggestions for a better structure....
>>
>> radix tree is efficient for dense sets, not sparse sets.
>
> Which actually works just fine for inodes on many filesystems if you
> use the right key.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
