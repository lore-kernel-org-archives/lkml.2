Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab1IVSci (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 14:32:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab1IVSci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 14:32:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: jens.axboe@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: blk_classic tracing horribly broken
References: <x491uv8h348.fsf@segfault.boston.devel.redhat.com>
	<20110922181216.GA13772@infradead.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 22 Sep 2011 14:32:29 -0400
In-Reply-To: <20110922181216.GA13772@infradead.org> (Christoph Hellwig's
	message of "Thu, 22 Sep 2011 14:12:16 -0400")
Message-ID: <x49wrd0fmwy.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Sep 22, 2011 at 01:57:11PM -0400, Jeff Moyer wrote:
>> Hi,
>> 
>> I've stared at the code for a while, and I've come up empty.  Would
>> anyone care to take a stab at fixing this?
>> 
>> To reproduce:
>> 
>> mount -t debugfs none /sys/kernel/debug
>> cd /sys/kernel/debug/tracing
>> echo blk > current_tracer
>> echo 1 > events/block/enable
>> echo 1 > options/blk_classic
>> echo 1 > tracing_on
>> 
>> dd if=/dev/<device> of=/dev/null bs=1M count=1 iflag=direct
>> cat trace
>
> Why are you using this interface anyway?  We actually had planned to
> drop it long time ago, but for some reason that never happened.

I was using it when testing the flush+fua reporting in blktrace, to be
sure we didn't break it.  Since it was already broken, I didn't have to
worry, but I put it on my todo list to investigate why.  Dropping broken
code is fine with me (given that there are two alternatives to use).

Cheers,
Jeff
