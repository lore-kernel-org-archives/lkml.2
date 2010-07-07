Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab0GGCEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 22:04:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17473 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0GGCEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 22:04:20 -0400
Date: Tue, 6 Jul 2010 19:03:13 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Tao Ma <tao.ma@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, ocfs2-devel@oss.oracle.com,
       Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
       Mark Fasheh <mfasheh@suse.com>
Subject: Re: [PATCH 1/2] ocfs2: Zero the tail cluster when extending past
 i_size v2
Message-ID: <20100707020313.GJ17961@mail.oracle.com>
Mail-Followup-To: Tao Ma <tao.ma@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Mark Fasheh <mfasheh@suse.com>
References: <20100629020420.GE24343@mail.oracle.com>
 <20100629022757.GA6590@dastard>
 <20100629071817.GA4150@mail.oracle.com>
 <20100702224912.GC5800@mail.oracle.com>
 <20100703213219.GB21262@mail.oracle.com>
 <4C3156D0.5090001@oracle.com>
 <20100706071741.GF13023@mail.oracle.com>
 <4C32E152.1090902@oracle.com>
 <20100706115827.GG13023@mail.oracle.com>
 <4C33CD8D.4070205@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C33CD8D.4070205@oracle.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C33E085.011B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 08:42:53AM +0800, Tao Ma wrote:
> >	Oh, you're right.  We need to walk the entire extent range
> >between i_size and pos and figure out what needs CoW.  This needs to
> >happen no matter what.
> Actually we can only have unwritten extents after i_size and it
> shouldn't hurt you in this case.
> So do we really need to CoW all the unwritten extents?
> All I want to say is that since they are unwritten, they should also
> mean 'zero' for the user space.
> So can we just need to skip clearing pages if i_size is in an
> unwritten extent?

	We can certainly have unwritten extents in the middle too ;-)
	I've just reworked the entire ocfs2_zero_extend() logic to skip
unwritten extents and CoW refcounted ones.  We have to CoW for nonsparse
anyway, so we needed this logic.  We do need to walk the entire range,
just in case there are extents anywhere between i_size and pos.
	Patches coming as soon as it stops breaking.

Joel

-- 

Life's Little Instruction Book #3

	"Watch a sunrise at least once a year."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
