Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab0FXTBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:01:07 -0400
Received: from exprod7og106.obsmtp.com ([64.18.2.165]:54081 "EHLO
	exprod7og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562Ab0FXTBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:01:05 -0400
X-Greylist: delayed 418 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2010 15:01:04 EDT
Message-ID: <4C23A90A.9040303@genband.com>
Date: Thu, 24 Jun 2010 12:50:50 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <20100618223354.GL2365@linux.vnet.ibm.com> <20100621170919.GA13826@redhat.com> <20100621205128.GI2354@linux.vnet.ibm.com> <20100622212357.GA19670@redhat.com> <20100622221226.GP2290@linux.vnet.ibm.com> <20100623152421.GA8445@redhat.com> <20100624180726.GK2373@linux.vnet.ibm.com>
In-Reply-To: <20100624180726.GK2373@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2010 18:53:01.0117 (UTC) FILETIME=[7835BED0:01CB13CE]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.000.1038-17466.001
X-TM-AS-Result: No--13.008100-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 12:07 PM, Paul E. McKenney wrote:

> 3.	The thread-group leader might do pthread_exit(), removing itself
> 	from the thread group -- and might do so while the hapless reader
> 	is referencing that thread.
> 
> 	But isn't this prohibited?  Or is it really legal to do a
> 	pthread_create() to create a new thread and then have the
> 	parent thread call pthread_exit()?  Not something I would
> 	consider trying in my own code!  Well, I might, just to
> 	be perverse, but...  ;-)

I believe SUS allows the main thread to explicitly call pthread_exit(),
leaving the other threads to run.  If the main() routine just returns
then it implicitly calls exit().

Chris

-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
