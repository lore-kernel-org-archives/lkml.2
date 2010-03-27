Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab0C0A62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:58:28 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:49255 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab0C0A60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:58:26 -0400
Date: Fri, 26 Mar 2010 17:57:11 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Yury Polyanskiy <ypolyans@princeton.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100327005710.GA31009@mail.oracle.com>
Mail-Followup-To: Yury Polyanskiy <ypolyans@princeton.edu>,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	john stultz <johnstul@us.ibm.com>,
	Jan Glauber <jan.glauber@de.ibm.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
 <20100326214648.GF9984@mail.oracle.com>
 <20100326180025.052d930f@penta.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100326180025.052d930f@penta.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BAD581E.0191:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 06:00:25PM -0400, Yury Polyanskiy wrote:
> On Fri, 26 Mar 2010 14:46:49 -0700
> Joel Becker <Joel.Becker@oracle.com> wrote:
> 
> > On Tue, Mar 23, 2010 at 11:36:11PM -0400, Yury Polyanskiy wrote:
> 
> > 1) Does getrawmonotonic() satisfy hangcheck-timer?  What I mean is, will
> > it always return the wallclock nanoseconds even in the face of CPU speed
> > changes, suspend, udelay, or any other suspension of kernel operation?
> > Yes, I know this is a tougher standard than rdtsc(), but this is what
> > hangcheck-timer wants.  rdtsc() at least satisfied udelay and PCI hangs.
> 
> Yes, as far as I can tell. Note that rdtsc is hosed on suspend-resume.

	Yeah, I know.  rdtsc hangcheck-timer really required no suspend
or cpufreq.  Since it is only really used by servers, this wasn't a
terrible restriction.  Then virtualization came along...

> > 2) If it does satisfy, why not use it for all hangcheck usage instead of
> > any ifdefs?
> 
> On my part, I didn't want to touch the S390 code since I can't test it.

	Makes sense.  Andrew, would you mind pushing this through your
tree?

Acked-by: Joel Becker <joel.becker@oracle.com>

Joel

-- 

Dort wo man Bücher verbrennt, verbrennt man am Ende auch Mensch.
(Wherever they burn books, they will also end up burning people.)
	- Heinrich Heine

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
