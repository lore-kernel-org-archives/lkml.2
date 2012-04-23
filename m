Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2DWXV1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 19:21:27 -0400
Received: from ms01.sssup.it ([193.205.80.99]:48264 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752055Ab2DWXV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 19:21:26 -0400
Message-ID: <4F95E3F1.3030407@sssup.it>
Date: Tue, 24 Apr 2012 00:21:21 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>   <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>  <1335182113.28150.132.camel@twins> <4F95CFBF.1050000@sssup.it> <1335218328.28150.181.camel@twins>
In-Reply-To: <1335218328.28150.181.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/04/2012 22:58, Peter Zijlstra ha scritto:
> On Mon, 2012-04-23 at 22:55 +0100, Tommaso Cucinotta wrote:
>> why not write this straight in asm, i.e., multiply 64*64 then divide by
>> 64 keeping the intermediate result on 128 bits?
> If you know of a way to do this for all 30 odd architectures supported
> by our beloved kernel, do let me know ;-)

:-)
> Yes I can do it for x86_64, but people tend to get mighty upset if you
> break the compile for all other arches...

rather than breaking compile, I was thinking more of using the 
optimization for a more accurate comparison on archs that have 64-bit 
mul and 128-bit cmp, and leaving the overflow on other archs. Though, 
that would imply a difference in behavior on those borderline cases 
(very big periods I guess).

However, I'm also puzzled from what would happen by compiling the 
current code on mostly 16-bit micros which have very limited 32-bit 
operations...

     T.

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

