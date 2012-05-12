Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab2ELLmw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 07:42:52 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:27446 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab2ELLmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 07:42:51 -0400
Message-ID: <4FAE4CB2.6010105@parallels.com>
Date: Sat, 12 May 2012 15:42:42 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Daniel Lezcano <dlezcano@fr.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] ns: Add proc_ns_operations for mount namespaces
References: <4FAD0524.3000307@parallels.com> <4FAD0555.4090906@parallels.com> <87d36a7imr.fsf@xmission.com>
In-Reply-To: <87d36a7imr.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 09:05 PM, Eric W. Biederman wrote:
> Pavel Emelyanov <xemul@parallels.com> writes:
> 
>> Currently LXC by default creates a container in a new mount
>> namespace. Thus in order to explore it we have to
>>
>> a) find out, that a new mount namespace is in use
>> b) enter this other namespace
>>
>> This patch solves both -- allows us to distinguish one mount
>> namespace from another by comparing its inode numbers and lets
>> us enter a mount namespace with the setns system call.
> 
> There are two significant bugs with your patch.
> 
> You do not set fs->root or fs->pwd to values in the new mount namespace,
> I don't believe there is anywhere else in the vfs where this is possible
> except possible fchdir.
> 
> It is easily possible to create a reference counting cycle by bind
> mounting the current mount namespace into itself.
> 
> Not that I am opposed to the concept I have just been dusting my patch
> for this same functionality off.

Oh, that's just perfect. Let's move your one then. Hopefully it won't
get covered with dust again.

> Eric
