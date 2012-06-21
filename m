Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab2FURrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 13:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61893 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760028Ab2FURrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 13:47:23 -0400
Message-ID: <4FE35DB9.10704@redhat.com>
Date: Thu, 21 Jun 2012 13:45:29 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        aarcange@redhat.com, minchan@gmail.com, kosaki.motohiro@gmail.com,
        andi@firstfloor.org, hannes@cmpxchg.org, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 4/7] mm: make page colouring code generic
References: <1340057126-31143-1-git-send-email-riel@redhat.com> <1340057126-31143-5-git-send-email-riel@redhat.com> <1340277624.21745.173.camel@twins> <4FE33002.6040703@redhat.com> <20120621104005.604fa9cc.akpm@linux-foundation.org>
In-Reply-To: <20120621104005.604fa9cc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2012 01:40 PM, Andrew Morton wrote:
> On Thu, 21 Jun 2012 10:30:26 -0400 Rik van Riel<riel@redhat.com>  wrote:
>
>> On 06/21/2012 07:20 AM, Peter Zijlstra wrote:
>>> On Mon, 2012-06-18 at 18:05 -0400, Rik van Riel wrote:
>>>> Fix the x86-64 page colouring code to take pgoff into account.
>>>
>>> Shouldn't that be a separate patch?
>>
>> My idea was that it would be easier to review
>> these two nearly identical functions together.
>>
>> Andrew, do you have any strong opinions?
>
> It depends on the significance of the change.  I suspect it's one of
> things which speeds up many workloads by 1.5% and slows down a few
> weird/important ones by 11%.  Which makes it a thing to be put under
> the microscope and poked at.  Some people might end up reverting it,
> making it tunable/configurable etc etc.
>
> If any of that is true then yes, I guess it should be a standalone thing.

Behaviour is not changed by this patch, except
for taking pgoff into account - which should not
matter a whole lot in practice, because mmap of
files is generally done starting at offset 0.
