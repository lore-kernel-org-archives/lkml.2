Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2HRVv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 17:51:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49960 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2HRVvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 17:51:54 -0400
Message-ID: <50300E9A.1060501@gmail.com>
Date: Sat, 18 Aug 2012 23:52:26 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/16] user_ns: use new hashtable implementation
References: <1344961490-4068-1-git-send-email-levinsasha928@gmail.com> <1344961490-4068-3-git-send-email-levinsasha928@gmail.com> <87txw5hw0s.fsf@xmission.com>
In-Reply-To: <87txw5hw0s.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 01:52 AM, Eric W. Biederman wrote:
> Sasha Levin <levinsasha928@gmail.com> writes:
>> > Switch user_ns to use the new hashtable implementation. This reduces the amount of
>> > generic unrelated code in user_ns.
> Two concerns here.
> 1) When adding a new entry you recompute the hash where previously that
>    was not done.  I believe that will slow down adding of new entries.

Since the hashtable doesn't expose the internal hashing to the user of the
hashtable it would require adding a new interface to deal with in.

I don't feel that a whole new interface to optimize out something which is very
cheap (one multiplication + shift) in this case, I'd rather avoid having a new
interface.

Is it ok with you if I leave it as is in the next version of the patch?
