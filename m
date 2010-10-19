Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab0JSI6e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 04:58:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56935 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757572Ab0JSI6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 04:58:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EjUiyIZutejRA4UMM3zC+MtLn1TYIrBxQqYjOe557/39w/kJRYhzEDzdeSadGqgcwR
         7fvMj72TTDx6aPI7teztQs+4/L4OJv4bSd8H/uRPvQGDpQPVqUZXcVwcGCGnKWjUbdkx
         ZJQvnRH9snlVrMX5yeEfT0GIphXnQKHCYYOX8=
Date: Tue, 19 Oct 2010 17:03:04 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Brian Gitonga Marete <marete@toshnix.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] [PERF] (Userspace Tools) Fix a compilation error with
 -fstack-protector and -Werror
Message-ID: <20101019090304.GA5211@cr0.nay.redhat.com>
References: <AANLkTinHc7tMntW5NFAhu40RC7m2=HwbqOBeE-21vL8J@mail.gmail.com>
 <20101018233834.GC5370@nowhere>
 <AANLkTi=Ssz4WdMDXq-93GE9bPHoaQ8QyTSrWXDSCa7eH@mail.gmail.com>
 <20101019064000.GC21782@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019064000.GC21782@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 08:40:00AM +0200, Ingo Molnar wrote:
>
>* Brian Gitonga Marete <marete@toshnix.com> wrote:
>
>> On Tue, Oct 19, 2010 at 2:38 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> > On Tue, Oct 19, 2010 at 02:24:00AM +0300, Brian Gitonga Marete wrote:
>> >> The following patch fixes compilation of the perf user-space tools on,
>> >> for example, gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) . It should not
>> >> break anything else.
>> >
>> >
>> >
>> > Hi,
>> >
>> > What kind of warning have you encountered and why it fixes it?
>> > Can you describe that in your changelog?
>> >
>> 
>> Hello Frederic,
>> 
>> Some versions of gcc, e.g. gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4), have the 
>> (default) minimum size of buffers protected by `-fstack-protector' set to 8. But 
>> in perf, there exist much smaller automatic buffers.
>
>Hm, it's this code:
>
>        /* newtWinChoice should really be accepting const char pointers... */
>        char yes[] = "Yes", no[] = "No";
>        return newtWinChoice(NULL, yes, no, (char *)msg) == 1;
>
>I.e. the code is messy and GCC is right to warn about it. Hence it would be somewhat 
>bad to actually remove the warning that pointed out some dodgy piece of code.

Agreed.

>
>Even if marking it const doesnt work due to the external libnewt API, we could at 
>least put 'yes' and 'no' into file scope and mark them static?
>

How about making ui__dialog_yesno() a macro? ;) Like:

#define ui__dialog_yesno(msg) \
	({newWinChoice(NULL, "Yes", "No", (char *)(msg)) == 1;})
