Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2HBQeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:34:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49737 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747Ab2HBQeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:34:19 -0400
Message-ID: <501AAC26.6030703@gmail.com>
Date: Thu, 02 Aug 2012 18:34:46 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Josh Triplett <josh@joshtriplett.org>, Tejun Heo <tj@kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
References: <20120731182330.GD21292@google.com> <50197348.9010101@gmail.com> <20120801182112.GC15477@google.com> <50197460.8010906@gmail.com> <20120801182749.GD15477@google.com> <50197E4A.7020408@gmail.com> <20120801202432.GE15477@google.com> <5019B0B4.1090102@gmail.com> <20120801224556.GF15477@google.com> <501A4FC1.8040907@gmail.com> <20120802103244.GA23318@leaf> <501A633B.3010509@gmail.com> <87txwl1dsq.fsf@xmission.com>
In-Reply-To: <87txwl1dsq.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 06:03 PM, Eric W. Biederman wrote:
> Sasha Levin <levinsasha928@gmail.com> writes:
>> On 08/02/2012 12:32 PM, Josh Triplett wrote:
>>> What about using a C99 flexible array member?  Kernel style prohibits
>>> variable-length arrays, but I don't think the same rationale applies to
>>> flexible array members.
>>>
>>> struct hash_table {
>>>     size_t count;
>>>     struct hlist_head buckets[];
>>> };
>>>
>>> #define DEFINE_HASH_TABLE(name, length) struct hash_table name = { .count = length, .buckets = { [0 ... (length - 1)] = HLIST_HEAD_INIT } }
>>
>> The limitation of this approach is that the struct hash_table variable
>> must be 'static', which is a bit limiting - see for example the use of
>> hashtable in 'struct user_namespace'.
> 
> You mean the hash table that was made static in 3.5?
> 
> You might want to try basing your patches on something a little more current.
> 
> Eric
> 

Heh, I've started working on it in April, and just returned to this. Didn't think about rebasing to something new.

will fix - Thanks!
