Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0C0Xhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 19:37:42 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:61759 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0C0Xhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 19:37:41 -0400
Date: Sat, 27 Mar 2010 16:36:30 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Yury Polyanskiy <ypolyans@princeton.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100327233630.GB1810@mail.oracle.com>
Mail-Followup-To: Yury Polyanskiy <ypolyans@princeton.edu>,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	john stultz <johnstul@us.ibm.com>,
	Jan Glauber <jan.glauber@de.ibm.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
 <20100326214648.GF9984@mail.oracle.com>
 <20100326180025.052d930f@penta.localdomain>
 <20100327005710.GA31009@mail.oracle.com>
 <20100326220259.702859e9@penta.localdomain>
 <20100327220355.GA1810@mail.oracle.com>
 <ea182b21003271551k10d0ef1oa0757ba921f1870f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea182b21003271551k10d0ef1oa0757ba921f1870f@mail.gmail.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4BAE9699.00B9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 06:51:01PM -0400, Yury Polyanskiy wrote:
> >        It's OK to tell hangcheck-timer users that suspend is not
> > allowed.  After all, you're running something that you don't want to see
> > hang.
> 
> Joel, what I am saying is exactly the opposite: it is totally ok to
> suspend-resume with hangcheck-timer (jiffies are stopped and so is
> getrawmonotonic() when system suspended).

	Nope.  The point of hangcheck-timer is that it reboots should
the system not be running for a certain amountof time.  If
suspend-resume is allowed, a system can resume after days and think it
wasn't more than a second.  hangcheck-timer will not know to reboot.

> >        Is there a clock in the system that is a true wallclock?  I'm
> > guessing, since getrawmonotonic() is get_cycles() based, that it doesn't
> > provide accurate time in the face of cpufreq changes.  Is that true?
> 
> Of course, getrawmonotonic accounts for cpufreq changes (see
> arch/x86/kernel/tsc.c:time_cpufreq_notifier()).

	Excellent!  That's a definite improvement over raw get_cycles().

Joel

-- 

Life's Little Instruction Book #182

	"Be romantic."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
