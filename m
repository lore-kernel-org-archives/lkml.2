Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab2BAAXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 19:23:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54840 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab2BAAXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 19:23:16 -0500
Message-ID: <4F2885EC.8070900@gmail.com>
Date: Wed, 01 Feb 2012 11:23:08 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        codalist@TELEMANN.coda.cs.cmu.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] coda: Remove unnecessary OOM messages
References: <cover.1328049542.git.joe@perches.com>	 <db4ffce1e5a8a3a6e54e7a4f6487e822709dbdba.1328049542.git.joe@perches.com>	 <4F288178.4040405@gmail.com> <1328055665.14714.5.camel@joe2Laptop>
In-Reply-To: <1328055665.14714.5.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/12 11:21, Joe Perches wrote:

>> Since CODA_ALLOC no longer uses __FILE__ and __LINE__ and doesn't use
>> the cast argument any more, it can be replaced with a static inline
>> function. Something like this (untested, applies on top of your patch):
> 
> Hi Ryan.
> 
> I didn't want to be quite so invasive
> but this looks like a nice cleanup to me.

Yeah, it needed to be done as a separate patch. Just a good time to do
it now that it no longer needs to be a macro.

> Maybe because alloc/free functions are
> used relatively infrequently, maybe it'd
> be better to not declare the functions
> inline but add them to coda_linux.c


Sure, either approach is fine. Do you want to add the patch to your series?

~Ryan

> 
>> +static inline void *coda_alloc(size_t size)
>> +{
>> +	if (size < PAGE_SIZE)
>> +		return kzalloc(size, GFP_KERNEL);
>> +	return vzalloc(size);
>> +}
> []
>> +static inline void coda_free(const void *ptr, size_t size)
>> +{
>> +	if (size < PAGE_SIZE)
>> +		kfree(ptr);
>> +	else
>> +		vfree(ptr);
>> +}
> 
> 


