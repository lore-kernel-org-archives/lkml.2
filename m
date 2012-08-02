Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab2HBVqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 17:46:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62029 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab2HBVqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 17:46:35 -0400
Message-ID: <501AF555.3050004@gmail.com>
Date: Thu, 02 Aug 2012 23:47:01 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
References: <5019B0B4.1090102@gmail.com> <20120801224556.GF15477@google.com> <501A4FC1.8040907@gmail.com> <20120802103244.GA23318@leaf> <501A633B.3010509@gmail.com> <501A7AD3.7000008@gmail.com> <20120802161556.GA25572@leaf> <501AAF47.3090708@gmail.com> <20120802174457.GA6251@jtriplet-mobl1> <501ABEE2.10007@gmail.com> <20120802204157.GB7916@jtriplet-mobl1>
In-Reply-To: <20120802204157.GB7916@jtriplet-mobl1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 10:41 PM, Josh Triplett wrote:
> On Thu, Aug 02, 2012 at 07:54:42PM +0200, Sasha Levin wrote:
>> /* I've "preprocessed" the DEFINE macro below */
>> union {
>> 	struct hash_table table;
>> 	struct {
>> 		size_t bits;
>> 		struct hlist_head buckets[32];
>> 	}
>> } my_hashtable;
> 
> That expansion doesn't match the macros.  Using the most recent
> definitions of DEFINE_HASHTABLE and DEFINE_STATIC_HASHTABLE from above,
> the definition would look something like this:
> 
> static union {
> 	struct hash_table my_hashtable;
> 	struct {
> 		size_t bits;
> 		struct hlist_head buckets[1 << 5];
> 	} __my_hashtable;
> } = { .my_hashtable.bits = 5 };

It's different because I don't think you can do what you did above with global variables.

You won't be defining any instances of that anonymous struct, so my_hashtable won't exist anywhere.
