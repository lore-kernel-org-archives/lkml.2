Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab2FDGhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 02:37:38 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64141 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2FDGhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 02:37:37 -0400
Message-ID: <4FCC57AD.3000803@lwfinger.net>
Date: Mon, 04 Jun 2012 01:37:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question about do_mmap changes
References: <4FCC47C9.8050904@lwfinger.net> <20120604062604.GV30000@ZenIV.linux.org.uk>
In-Reply-To: <20120604062604.GV30000@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 01:26 AM, Al Viro wrote:
> On Mon, Jun 04, 2012 at 12:29:45AM -0500, Larry Finger wrote:
>> Al,
>>
>> In commit e3fc629d7bb70848fbf479688a66d4e76dff46ac in 3.5-rc1, you
>> change do_mmap() to static, and use do_mmap_pgoff() instaed. The
>> VirtualBox kernel module calls do_mmap(), and no longer compiles. I
>> fixed the compile problem with the patch
> [snip]
>> I am not quite sure why do_munmap() is undefined as the symbol is
>> exported; however, should do_mmap_pgoff() be exported?
>
> a) you'd better make very certain that you are holding ->mmap_sem on
> current->mm; I couldn't verify that.
>
> b) as for rtR0MemObjLinuxDoMmap(), I would suggest pulling down_write()/
> up_write() on ->mmap_sem into the function, collapsing them down into
> do_mmap() turning it into vm_mmap().  Oh, and probably breaking wrists
> to whoever had come up with that function name, but that's a matter of
> taste.  Some prefer kneecaps.
>
> c) WTF is MY_DO_MUNMAP() and are you guaranteed that you are doing that to
> current->mm and not to something else?  If not, you have a big problem;
> if yes, convert to vm_munmap().
>
> Again, doing mmap/munmap to some random process' mm is a bloody bad idea;
> there's a shitload of races in that area.

Oh, shit. I was hoping for an easy conversion of this code to work with 3.5 so 
that I could use VB while testing 3.5. Clearly, the fixes will not be quick.

As you have likely gathered, I am not a VB developer. Is it OK if I pass your 
comments on to the real developers and let them do the work?

Thanks,

Larry

