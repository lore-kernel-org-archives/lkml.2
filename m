Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2KEJIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 04:08:51 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:52387 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab2KEJIt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Mon, 5 Nov 2012 04:08:49 -0500
Message-Id: <5097902C02000078000A64BF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 05 Nov 2012 09:08:44 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sscanf: don't ignore field widths for numeric
 conversions
References: <5093EA4802000078000A61D4@nat28.tlf.novell.com>
 <20121102143247.6c581e16.akpm@linux-foundation.org>
In-Reply-To: <20121102143247.6c581e16.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 02.11.12 at 22:32, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 02 Nov 2012 14:44:08 +0000
> "Jan Beulich" <JBeulich@suse.com> wrote:
> 
>> This is another step towards better standard conformance. Rather than
>> adding a local buffer to store the specified portion of the string
>> (with the need to enforce an arbitrary maximum supported width to
>> limit the buffer size), do a maximum width conversion and then drop as
>> much of it as is necessary to meet the caller's request.
>> 
>> Also fail on negative field widths.
>> 
>> ...
>>
>> +				simple_strtol(str, &next, base) :
> 
> simple_strtol() kerndoc says "This function is obsolete.  Please use
> kstrtol instead."  Can we?

No, we can't - kstrtoXX() fail on non-zero terminated strings. If
anything we'd have to switch to using the parsing functions
underlying _kstrtoXX() (effectively open-coding simple_strtoXX()),
but other than a simply replacement as you suggest (and as I had
intended originally) I wouldn't want to put _that_ change into this
same patch.

I think the simple_strtoXX() functions are sitting inside lib/vsprintf.c
for a good reason, and the obsoletion aspect of them should
merely involve their status of not only not being static, but even
being exported. Their use as helper functions ought to be fine
within that file.

Jan

