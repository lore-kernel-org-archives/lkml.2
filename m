Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab1FFR1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:27:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35027 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1FFR1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:27:11 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=XYJHFtupD_QA:10 a=cI1dXKbxrVUA:10 a=5SG0PmZfjMsA:10 a=8nJEP1OIZ-IA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=mDV3o1hIAAAA:8 a=h4GOTxmpWQMXSQ9dSB4A:9 a=wPNLvfGTeEIA:10 a=dFHnE2QzQF8A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Mon, 6 Jun 2011 13:27:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
Message-ID: <20110606172707.GB27245@home.goodmis.org>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
 <1307373819.3098.40.camel@edumazet-laptop>
 <1307376672.2322.167.camel@twins>
 <1307376989.2322.171.camel@twins>
 <1307377349.3098.65.camel@edumazet-laptop>
 <1307377782.2322.183.camel@twins>
 <1307378564.3098.67.camel@edumazet-laptop>
 <1307379926.2322.219.camel@twins>
 <1307380297.3098.74.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307380297.3098.74.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 06, 2011 at 07:11:37PM +0200, Eric Dumazet wrote:
> Le lundi 06 juin 2011 à 19:05 +0200, Peter Zijlstra a écrit :
> 
> > Dunno, using futexes on private file maps is stupid imo, its just asking
> > for trouble, ro private file maps are even worse. Forcing the COW is the
> > only sane answer in that it gives consistent results and 'breaks' silly
> > expectations early instead of sometimes.
> > 
> > Anyway, that's not really the issue here, as David uses MAP_SHARED (as
> > one should if one is interested in the shared value).
> 
> Sure, but maybe another guy is 'stupid' and uses MAP_PRIVATE on its
> read-only mappings. With old kernels this was working, and we were not
> doing the COW.

That sounds like a bug in both the kernel and userspace. I would expect
a MAP_PRIVATE not be seen by any other process regardless. That's the
definition of PRIVATE.

 From: http://www.gnu.org/s/hello/manual/libc/Memory_002dmapped-I_002fO.html

MAP_PRIVATE
    This specifies that writes to the region should never be written back
    to the attached file. Instead, a copy is made for the process, and the
    region will be swapped normally if memory runs low. No other process
    will see the changes. 

-- Steve
