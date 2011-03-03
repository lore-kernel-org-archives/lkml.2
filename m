Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab1CCQSN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 11:18:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab1CCQSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 11:18:11 -0500
From: Andreas Schwab <schwab@redhat.com>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] st_nlink after rmdir() and rename()
References: <20110303032454.GI22723@ZenIV.linux.org.uk>
	<406B4874-D3D8-4C05-9FA5-8A7A18ABF89C@mit.edu>
X-Yow: Send your questions to ``ASK ZIPPY'', Box 40474,
 San Francisco, CA 94140, USA
Date: Thu, 03 Mar 2011 17:17:32 +0100
In-Reply-To: <406B4874-D3D8-4C05-9FA5-8A7A18ABF89C@mit.edu> (Theodore Tso's
	message of "Thu, 3 Mar 2011 09:34:08 -0500")
Message-ID: <m3y64wyy8z.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@MIT.EDU> writes:

> On Mar 2, 2011, at 10:24 PM, Al Viro wrote:
>
>> We have an interesting problem.  Consider the following sequence
>> of syscalls:
>> 	mkdir("foo", 0777);
>> 	mkdir("bar", 0777);
>> 	fd1 = open("foo", O_DIRECTORY);
>> 	fd2 = open("bar", O_DIRECTORY);
>> 	rename("foo", "bar");	/* kill old bar */
>
> I must be missing something.  I didn't think you could rename on
> top of a directory and have the directory disappear.  Don't you get
> an error in that case?

rename is required to be able to move a directory over an empty
directory, atomically.

> What happens if bar contains files?

That's an error.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."
