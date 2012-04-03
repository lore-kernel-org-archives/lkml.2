Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab2DCGC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 02:02:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38648 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab2DCGC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 02:02:58 -0400
Date: Tue, 3 Apr 2012 08:02:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.4-rc1 crash]: NULL pointer deref in
 fs/sysfs/group.c:create_files -- sysctl related?
Message-ID: <20120403060252.GA27084@gmail.com>
References: <20120402162716.4c93bfd3@pluto.restena.lu>
 <20120402165036.2bc987ad@pluto.restena.lu>
 <m17gxyklfm.fsf@fess.ebiederm.org>
 <20120402213440.49e9de74@neptune>
 <1333401898.2960.78.camel@laptop>
 <1333403193.2960.80.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1333403193.2960.80.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, 2012-04-02 at 23:24 +0200, Peter Zijlstra wrote:
> > On Mon, 2012-04-02 at 21:34 +0200, Bruno Prémont wrote:
> > > > >> [    0.996198] Pid: 1, comm: swapper/0 Not tainted 3.4.0-rc1-x86_64 #3 HP ProLiant DL360 G4
> > 
> > Is this a netburst based space heater?
> 
> In particular, does: https://lkml.org/lkml/2012/3/27/182 , sort it?
> 
> Ingo, could you pick that one up and route it Linus wards?

Will do - but the underlying generic bug should be fixed as 
well: we must not crash just because some attributes are missing 
in a rarely used sub-driver ...

We should WARN_ON(), etc. - but not crash.

Thanks,

	Ingo
