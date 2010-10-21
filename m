Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab0JUPOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:14:54 -0400
Received: from BERING.ISR.CS.CMU.EDU ([128.2.209.223]:50360 "EHLO
	bering.isr.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0JUPOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 11:14:53 -0400
Message-ID: <4CC058EC.1060200@cs.cmu.edu>
Date: Thu, 21 Oct 2010 11:14:52 -0400
From: Jan Harkes <jaharkes@cs.cmu.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100913 Iceowl/1.0b1 Icedove/3.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/3] Coda: remove BKL
References: <1287606184-26889-1-git-send-email-jaharkes@cs.cmu.edu> <201010211108.41320.arnd@arndb.de>
In-Reply-To: <201010211108.41320.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 05:08 AM, Arnd Bergmann wrote:
> On Wednesday 20 October 2010, Jan Harkes wrote:
>> The following three patches remove the big kernel lock from the Coda
>> file system kernel module. We initially add a spinlock to protect the
>> Coda-specific inode data. After this we can push the BKL all the way
>> down to where the requests are queued for the userspace Coda cache
>> manager process and finally we replace the remaining BKL uses with a
>> mutex that protects the upcall queues.
> 
> Very nice!
> 
> Are you pushing this to Linus or should I take care of it along with
> the other file systems?
> 
> This patch is larger than most of the others, but I can add it to
> my bkl/vfs tree if you like.

In that case it might be better when pushed separately, just to avoid
any chances on a merge conflict for the bkl/vfs tree. I was thinking of
letting the initial merges hit, rebase and retest over the weekend if
there were any Coda related changes, and sending the final version to
Linus by monday.

Besides, that gives me a couple of more days to make sure I weed out any
remaining issues.

Jan
