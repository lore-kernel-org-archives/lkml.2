Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab0C2TzV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:55:21 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:56317 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0C2TzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:55:19 -0400
Date: Mon, 29 Mar 2010 12:53:20 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Yury Polyanskiy <ypolyans@princeton.edu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100329195320.GA12499@mail.oracle.com>
Mail-Followup-To: john stultz <johnstul@us.ibm.com>,
	Yury Polyanskiy <ypolyans@princeton.edu>,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	Jan Glauber <jan.glauber@de.ibm.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
 <20100326214648.GF9984@mail.oracle.com>
 <1269824436.1880.2.camel@work-vm>
 <20100329101106.3678a312@penta.localdomain>
 <1269881007.1857.18.camel@work-vm>
 <20100329130418.2b5c068c@penta.localdomain>
 <1269888291.3968.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269888291.3968.5.camel@localhost.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BB10599.015F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 11:44:51AM -0700, john stultz wrote:
> > But if timer interrupt is delayed by more than acpi_pm wrap-around
> > time, then the update_wall_time() is also screwed. Since it is not, we
> > can rely on getrawmonotonic().
> 
> Right, if the box hangs for longer then the clocksource can count for,
> the timekeeping subsystem will be off by some multiple of that length.
> 
> And That's exactly why I'm advising against using
> gettimeofday/getrawmonotonic or any other software managed sense of time
> for the hangcheck timer, as you won't be able to correctly detect hangs.
> 
> I'm also suggesting using something like read_persistent_clock() is
> better, because there is no OS/software management involved (other then
> the minor syncing issue I mentioned before) so if the system hangs for a
> long period of time, then returns, you'll still be able to detect the
> hang.
> 
> But maybe what folks are using the hangcheck timer for is shifting, so
> its possible that I'm not quite understanding what you're trying to do
> here.

	The people who use hangcheck-timer for the reasons I originally
wrote it absolutely want any hang, including long ones, detected.

Joel

-- 

"For every complex problem there exists a solution that is brief,
     concise, and totally wrong."
                                        -Unknown

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
