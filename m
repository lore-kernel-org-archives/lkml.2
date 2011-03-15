Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab1COQ1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:27:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:59019 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab1COQ1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:27:32 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: dave <dave@jikos.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        adilger <adilger@dilger.ca>
Subject: Re: ext4 deep stack with mark_page_dirty reclaim
In-reply-to: <20110315152222.GW17108@twin.jikos.cz>
References: <alpine.LSU.2.00.1103141156190.3220@sister.anvils> <20110314204627.GB8120@thunk.org> <FE7209AC-C66C-4482-945E-58CF5AF8FEE7@dilger.ca> <20110315152222.GW17108@twin.jikos.cz>
Date: Tue, 15 Mar 2011 12:26:43 -0400
Message-Id: <1300206353-sup-9759@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D7F9367.00A3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from David Sterba's message of 2011-03-15 11:22:22 -0400:
> On Mon, Mar 14, 2011 at 07:25:10PM -0700, Andreas Dilger wrote:
> > Is there a script which you used to generate this stack trace to
> > function size mapping, or did you do it by hand?  I've always wanted
> > such a script, but the tricky part is that there is so much garbage on
> > the stack that any automated stack parsing is almost useless.
> > Alternately, it would seem trivial to have the stack dumper print the
> > relative address of each symbol, and the delta from the previous
> > symbol...
> 
> > > 240 schedule+0x25a
> > > 368 io_schedule+0x35
> > >  32 get_request_wait+0xc6
> 
> from the callstack:
> 
> ffff88007a704338 schedule+0x25a
> ffff88007a7044a8 io_schedule+0x35
> ffff88007a7044c8 get_request_wait+0xc6
> 
> subtract the values and you get the ones Ted posted,
> 
> eg. for get_request_wait:
> 
> 0xffff88007a7044c8 - 0xffff88007a7044a8 = 32
> 
> There'se a script scripts/checkstack.pl which tries to determine stack
> usage from 'objdump -d' looking for the 'sub 0x123,%rsp' instruction and
> reporting the 0x123 as stack consumption. It does not give same results,
> for the get_request_wait:
> 
> ffffffff81216205:       48 83 ec 68             sub    $0x68,%rsp
> 
> reported as 104.

Also, the ftrace stack usage tracer gives more verbose output that
includes the size of each function.

-chris
