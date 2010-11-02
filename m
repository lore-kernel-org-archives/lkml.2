Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab0KBLLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 07:11:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab0KBLLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 07:11:04 -0400
Message-ID: <4CCFF1BA.1010206@redhat.com>
Date: Tue, 02 Nov 2010 07:10:50 -0400
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Christopher Yeoh <cyeoh@au1.ibm.com>
CC: Bryan Donlan <bdonlan@gmail.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Cross Memory Attach
References: <20100915104855.41de3ebf@lilo>	<4C90A6C7.9050607@redhat.com>	<AANLkTi=rmUUPCm212Sju-wW==5cT4eqqU+FEP_hX-Z_y@mail.gmail.com>	<20100916104819.36d10acb@lilo>	<4C91E2CC.9040709@redhat.com> <20101102140710.5f2a6557@lilo>
In-Reply-To: <20101102140710.5f2a6557@lilo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 11/01/2010 11:37 PM, Christopher Yeoh wrote:
> >
> >  You could have each process open /proc/self/mem and pass the fd using
> >  SCM_RIGHTS.
> >
> >  That eliminates a race; with copy_to_process(), by the time the pid
> >  is looked up it might designate a different process.
>
> Just to revive an old thread (I've been on holidays), but this doesn't
> work either. the ptrace check is done by mem_read (eg on each read) so
> even if you do pass the fd using SCM_RIGHTS, reads on the fd still
> fail.
>
> So unless there's good reason to believe that the ptrace permission
> check is no longer needed, the /proc/pid/mem interface doesn't seem to
> be an option for what we want to do.
>

Perhaps move the check to open().  I can understand the desire to avoid 
letting random processes peek each other's memory, but once a process 
has opened its own /proc/self/mem and explicitly passed it to another, 
we should allow it.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

