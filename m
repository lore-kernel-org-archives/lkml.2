Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1HVN1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:27:04 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61408 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1HVN1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:27:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110822131621.GS2203@ZenIV.linux.org.uk>
References: <4E51CFD8.2090508@gmail.com>
	<CA+5PVA6KUMDEygjxrqwvpRDNfJ3WobUs7rwyP+pZrX9-atZUgw@mail.gmail.com>
	<20110822131621.GS2203@ZenIV.linux.org.uk>
Date: Mon, 22 Aug 2011 09:27:01 -0400
Message-ID: <CA+5PVA5GcDMSLxQJb-HhqokA+vZuDvnQN3bsmucmk30mVHN+0A@mail.gmail.com>
Subject: Re: INFO: possible circular locking dependency detected 3.1.0-rc2-00190-g3210d19
From: Josh Boyer <jwboyer@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, "Theodore Ts'o" <tytso@mit.edu>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 9:16 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Aug 22, 2011 at 09:09:14AM -0400, Josh Boyer wrote:
>
>> We've had a report of this on 3.0.1 as well.  Slightly different
>> scenario and fs, but the locks in question are the same.
>> https://bugzilla.redhat.com/show_bug.cgi?id=730998
>>
>> It seems that with CONFIG_PROVE_LOCKING on, might_fault will always
>> attempt to grab mm->mmap_sem.  The common flow here is that getdents
>> calls filldir, which calls copy_to_user, which is what is calling
>> might_fault.
>>
>> Beyond that, I'm a bit over my head at the moment because I don't know
>> if the VFS is right and we just need some more lockdep annotations or
>> if there really is a problem.
>
> Don't grab ->i_mutex in ->evict_inode().  Why are you doing that, anyway?

I've no idea.  Let's ask Ted!

josh
