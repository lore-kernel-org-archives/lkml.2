Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab2IDTn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:43:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60485 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757657Ab2IDTny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:43:54 -0400
Date: Tue, 4 Sep 2012 12:43:50 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 9/9] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120904194350.GD25236@google.com>
References: <Pine.LNX.4.64.1208291210180.774@file.rdu.redhat.com>
 <20120829165006.GB20312@google.com>
 <20120829170711.GC12504@redhat.com>
 <20120829171345.GC20312@google.com>
 <20120830220745.GI27257@redhat.com>
 <20120831014359.GB15218@moria.home.lan>
 <Pine.LNX.4.64.1209031638110.15620@file.rdu.redhat.com>
 <20120904034100.GA21602@moria.home.lan>
 <20120904185540.GC3638@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120904190119.GD3638@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120904190119.GD3638@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 12:01:19PM -0700, Tejun Heo wrote:
> On Tue, Sep 04, 2012 at 11:55:40AM -0700, Tejun Heo wrote:
> > Actually, if the timer approach can reduce the frequency of rescuer
> > involvement, I think it could actually be better.
> 
> Ooh, it wouldn't.  It's kicking in only after alloc failure.  I don't
> know.  I think conditioning it on alloc failure is cleaner and
> converting all per-bio allocations to front-pad makes sense.  Using a
> timer wouldn't make the mechanism any simpler, right?

Exactly
