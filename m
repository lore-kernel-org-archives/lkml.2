Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab0DZS7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 14:59:05 -0400
Received: from stephens.ittc.ku.edu ([129.237.125.220]:53304 "EHLO
	stephens.ittc.ku.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab0DZS7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 14:59:00 -0400
X-Greylist: delayed 1315 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2010 14:59:00 EDT
Message-ID: <4BD5DD4F.5080906@ittc.ku.edu>
Date: Mon, 26 Apr 2010 13:37:03 -0500
From: Doug Niehaus <niehaus@ittc.ku.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Lightning/1.0b1 Thunderbird/3.0.4 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Ted Baker <baker@cs.fsu.edu>, raj@ece.cmu.edu, jayhawk@soe.ucsc.edu,
       a.p.zijlstra@chello.nl, raistlin@linux.it, henrik@austad.us,
       linux-kernel@vger.kernel.org, mingo@elte.hu, billh@gnuppy.monkey.org,
       linux-rt-users@vger.kernel.org, fabio@gandalf.sssup.it,
       anderson@cs.unc.edu, tglx@linutronix.de, dhaval.giani@gmail.com,
       cucinotta@sssup.it, lipari@retis.sssup.it, baker.tlh@comcast.net
Subject: Re: [Fwd: Re: RFC for a new Scheduling policy/class in the	Linux-kernel]
References: <20100426115658.GA21346@cs.fsu.edu> <20100426182903.GA14542@8bytes.org>
In-Reply-To: <20100426182903.GA14542@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0.1 (stephens.ittc.ku.edu); Mon, 26 Apr 2010 13:37:03 -0500 (CDT)
X-ITTC-MailScanner-Information: Please contact the ISP for more information
X-ITTC-MailScanner-ID: 78C5328F5C.55B4E
X-ITTC-MailScanner: Found to be clean
X-ITTC-MailScanner-From: niehaus@ittc.ku.edu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One limitation of SIGSTOP is that the last time I instrumented it in 
detail, which admittedly was several years ago, every process you send 
the message to has to run long enough to receive the message.

We were in the the position of sending it to fairly large groups of 
processes, partly through laziness in code structure, but when I looked 
at the time lines I was appalled to see a large number of context 
switches for *very* short execution intervals. All were associated with 
receiving the SIGSTOP and SIGCONT.

I found a rather painful humor in the fact that we were running 
processes in order to keep them from running.

So, a way to change state of a process that does not cost a context 
switch has some appeal.

Doug

On 04/26/2010 01:29 PM, Joerg Roedel wrote:
> On Mon, Apr 26, 2010 at 07:56:58AM -0400, Ted Baker wrote:
>    
>> I have not seen any more e-mail on this.  How is it going?  Is there any
>> chance of rolling in some corrections for the SCHED_SPORADIC treatment?  In
>> particular, could we have a DO_NOT_RUN priority, that is guaranteed to
>> prevent a task from running at all?
>>      
> Sorry for asking a maybe stupid question, but what is this good for and
> what is the benefit over SIGSTOP?
>
> 	Joerg
>
>    
