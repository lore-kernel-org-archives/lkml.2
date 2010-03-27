Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab0C0WEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 18:04:35 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:24263 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab0C0WEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 18:04:34 -0400
Date: Sat, 27 Mar 2010 15:03:55 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Yury Polyanskiy <ypolyans@princeton.edu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, Jan Glauber <jan.glauber@de.ibm.com>
Subject: Re: [PATCH] hangcheck-timer is broken on x86
Message-ID: <20100327220355.GA1810@mail.oracle.com>
Mail-Followup-To: Yury Polyanskiy <ypolyans@princeton.edu>,
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
	john stultz <johnstul@us.ibm.com>,
	Jan Glauber <jan.glauber@de.ibm.com>
References: <20100323233611.6dcbe4f4@penta.localdomain>
 <20100326214648.GF9984@mail.oracle.com>
 <20100326180025.052d930f@penta.localdomain>
 <20100327005710.GA31009@mail.oracle.com>
 <20100326220259.702859e9@penta.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326220259.702859e9@penta.localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BAE80E3.011E:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 10:02:59PM -0400, Yury Polyanskiy wrote:
> Joel, just realized there is a slight mistake in what I said before.
> getrawmonotonic() is a refined jiffies (and actually resolves to
> get_cycles() on my system in the end). Thus it doesn't count while in
> suspend. However, jiffies-based timers (aka timer-wheel) are also
> stopped while in suspend. So getrawmonotonic() is the right call to
> check the precision of the jiffies-based timer (i.e. you dont need to
> make a correction by calling monotonic_to_bootbased()). 

	It's OK to tell hangcheck-timer users that suspend is not
allowed.  After all, you're running something that you don't want to see
hang.
	Is there a clock in the system that is a true wallclock?  I'm
guessing, since getrawmonotonic() is get_cycles() based, that it doesn't
provide accurate time in the face of cpufreq changes.  Is that true?

Joel



-- 

Life's Little Instruction Book #497

	"Go down swinging."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
