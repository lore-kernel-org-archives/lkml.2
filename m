Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab2B0SX1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:23:27 -0500
Received: from 8bytes.org ([88.198.83.132]:52726 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754346Ab2B0SX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:23:26 -0500
Date: Mon, 27 Feb 2012 19:23:25 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        mingo@elte.hu, gleb@redhat.com, joerg.roedel@amd.com
Subject: Re: [PATCH] perf tools: fix guest mode monitoring on AMD
Message-ID: <20120227182325.GA12302@8bytes.org>
References: <20120227173351.GA6945@quad> <4F4BC1AD.9030600@gmail.com> <CABPqkBRUzp-gBANhiMerHanN7yaTnJbxHNEjz_mw+XRYT8ZHUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRUzp-gBANhiMerHanN7yaTnJbxHNEjz_mw+XRYT8ZHUw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 06:52:25PM +0100, Stephane Eranian wrote:
> Yeah, but that causes simple commands such as "perf stat -e cycles ls"
> to return 0 count.
> 
> So either you get a segfault or you get zero count. There is something
> else going on here...

Hmm, looks like the counters will not do any counting when EFER.SVME==0
and HO==1 or GO==1 is set in the counters :(
A solution would be to mask out these bits in the perf-ctrl register
when EFER.SVME=0

I'll try to come up with a fix soon.


	Joerg

