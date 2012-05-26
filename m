Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2EZPOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 11:14:48 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:32895 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2EZPOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 11:14:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Daniel Lezcano <dlezcano@fr.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <4FAD0524.3000307@parallels.com> <877gwi7ije.fsf@xmission.com>
	<4FAE4C13.3040708@parallels.com>
Date: Sat, 26 May 2012 09:14:33 -0600
In-Reply-To: <4FAE4C13.3040708@parallels.com> (Pavel Emelyanov's message of
	"Sat, 12 May 2012 15:40:03 +0400")
Message-ID: <87r4u7ug86.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/JOnsJ1AFStQl1t+LQQRASCMfY/YvnkAA=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0061]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pavel Emelyanov <xemul@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/2] proc: Show ns-based inode numbers for /proc/pid/ns/* files
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelyanov <xemul@parallels.com> writes:

> On 05/11/2012 09:07 PM, Eric W. Biederman wrote:
>> Pavel Emelyanov <xemul@parallels.com> writes:
>> 
>>> Some time ago we tried to expose kernel object IDs to the user space to
>>> let it possible to detect shared mm, fs, etc. The namespaces' IDs were
>>> included in this set and Eric proposed, that we'd better expose the ID
>>> in the stat's st_ino field.
>> 
>> A quick question.  With kcmp you have something that is at least in
>> principle usable for checkpoint restart.
>
> Not only in principle. We do use it already ;)
>
>> Are wanting this for checkpoint restart or something else?
>
> For me -- checkpoint restart only. I'm perfectly fine with checking 
> namespaces sharing with kcmp syscall, but you proposed to show ns ID
> in proc inode.

I still think it makes a lot of sense to use stable inode number for
each filesystem.  I am travelling at the moment and I can't find a copy
of your original patch I plan to be home by the end of the week, so
I will have to dig it up then.

>From what I remember the something seemed off with your inode
generation.  From my quick glance earlier it looked a bit wrong.  My
earlier attempt was to essentially export
fs/proc/generic.c:get_inode_number and just have a field in the various
namespaces to store that number.  Plus a method to read that field.
Your patch from my memory seemd to be doing something more than that.

My original plan was to finish setns support before moving on to
stable inode numbers.  But that didn't work out.  I will reevaluate
as I sort out what I need to get done for the next merge window.

I was quite disappointed with the lack of review my mount namespace
patch got from Viro and the other vfs people.  So I think I will
probably have to host a tree myself.  At which point stable
inode support won't be hard. 

It would be good to have kcmp support for namespaces as well as having
an id.  I think the merged functionality in proc_ns_operations is
probably enough for kcmp as is.

Until I have had a few days to play after the merge window closes and
I can't say what I will really be doing but I do want to get this
chunk of work finished, it is definitely time.

Eric
