Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2BGQrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:47:42 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63083 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab2BGQrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:47:41 -0500
Date: Tue, 7 Feb 2012 08:47:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Shaohua Li <vivek.goyal2008@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Subject: Re: [PATCH] block: strip out locking optimization in
 put_io_context()
Message-ID: <20120207164735.GH21292@google.com>
References: <20120206163721.GF30752@redhat.com>
 <20120206164428.GA21292@google.com>
 <CA+55aFx6BR_ZUHd8d64btu-LzsPHo3Ot_d1-5jJytjQUqvvaiQ@mail.gmail.com>
 <20120206172706.GB21292@google.com>
 <4F303506.9000201@kernel.dk>
 <20120206215451.GD21292@google.com>
 <4F30C96F.1000905@kernel.dk>
 <20120207162253.GG21292@google.com>
 <4F315113.5010804@kernel.dk>
 <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Feb 07, 2012 at 08:33:15AM -0800, Linus Torvalds wrote:
> Yeah, please just get rid of the crazy code. Maybe *that* fixes the
> regression too, who knows?
> 
> For all we know, the "fast case" is what causes extra locking only to
> then fail and not even be a fast-path.

Yeah, I was about to ask Shaohua to test the version w/o optimization.
With heavily loaded request_queue, trylock failure could be frequent,
which I wasn't testing.

Shaohua, can you please test the version w/o optimization?  Also, can
you please give a bit more details on the setup?  Are there multiple
swap devices?  Is it SSD or rotating disk?

> I think our default action should always be to simplify and clean up
> code, unless you have seriously hard numbers to show that the code
> complexity is worth it.

Sure, it was originally all in put_io_context() and while moving
things to wq, it got progressively complex and I lost sense of
complexity from staring at it too long.

Thanks.

-- 
tejun
