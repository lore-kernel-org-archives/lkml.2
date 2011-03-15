Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab1COQDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:03:25 -0400
Received: from twin.jikos.cz ([89.185.236.188]:34650 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab1COQDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:03:24 -0400
X-Greylist: delayed 2442 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Mar 2011 12:03:24 EDT
Date: Tue, 15 Mar 2011 16:22:22 +0100
From: David Sterba <dave@jikos.cz>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: adilger@dilger.ca
Subject: Re: ext4 deep stack with mark_page_dirty reclaim
Message-ID: <20110315152222.GW17108@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	adilger@dilger.ca
References: <alpine.LSU.2.00.1103141156190.3220@sister.anvils>
 <20110314204627.GB8120@thunk.org>
 <FE7209AC-C66C-4482-945E-58CF5AF8FEE7@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FE7209AC-C66C-4482-945E-58CF5AF8FEE7@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 07:25:10PM -0700, Andreas Dilger wrote:
> Is there a script which you used to generate this stack trace to
> function size mapping, or did you do it by hand?  I've always wanted
> such a script, but the tricky part is that there is so much garbage on
> the stack that any automated stack parsing is almost useless.
> Alternately, it would seem trivial to have the stack dumper print the
> relative address of each symbol, and the delta from the previous
> symbol...

> > 240 schedule+0x25a
> > 368 io_schedule+0x35
> >  32 get_request_wait+0xc6

from the callstack:

ffff88007a704338 schedule+0x25a
ffff88007a7044a8 io_schedule+0x35
ffff88007a7044c8 get_request_wait+0xc6

subtract the values and you get the ones Ted posted,

eg. for get_request_wait:

0xffff88007a7044c8 - 0xffff88007a7044a8 = 32

There'se a script scripts/checkstack.pl which tries to determine stack
usage from 'objdump -d' looking for the 'sub 0x123,%rsp' instruction and
reporting the 0x123 as stack consumption. It does not give same results,
for the get_request_wait:

ffffffff81216205:       48 83 ec 68             sub    $0x68,%rsp

reported as 104.


dave
