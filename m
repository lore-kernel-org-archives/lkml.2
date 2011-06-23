Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703Ab1FWUCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:02:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56272 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab1FWUCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:02:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=yCqqDviPjZC0VLpRh2yKJNlM35UQz8844MPEaR6TU9Cm8Lcd366YXTHY5xaQjP5H7W
         YsmZkAiP04ViN4bbtm8khDxr24iEs/BiP1XjAdUxcLnhLz8ORR2eUnYgeAfL+/iI2occ
         BWfYhKDOxkyru+yHFMmWWyrYiPlCdxtBT02lM=
Message-ID: <4E039BC7.4050802@gmail.com>
Date: Thu, 23 Jun 2011 14:02:15 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arun Sharma <asharma@fb.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Using a new perf tool against an older kernel
References: <4E026123.4060208@fb.com> <4E034C2C.30509@gmail.com> <4E03968A.5010008@fb.com>
In-Reply-To: <4E03968A.5010008@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/23/2011 01:39 PM, Arun Sharma wrote:
> On 6/23/11 7:22 AM, David Ahern wrote:
> 
>> I have not seen issues like this using newer perf userspace against
>> older kernels. For example, my laptop was running Fedora 14 (2.6.35) and
>> now Fedora 15 (2.6.38.8) and I typically use latest perf builds (e.g.,
>> testing patches).
> 
> I narrowed it down to PERF_SAMPLE_RAW:
> 
> perf record -ag -- sleep 1
> 
> is fine, but:
> 
> perf record -agR -- sleep 1
> 
> fails for me most of the time. The reason I needed to use the -R in the
> first place is that "perf script" fails on older kernels with:
> 
> Samples do not contain timestamps.
> 
> With the newer perf, I don't get errors, but the timestamp field is
> invalid. So I need to use the -R flag to get valid timestamps +
> stacktraces out of "perf script".

That should have been fixed.

And -T on record gets the timestamps.

David

> 
>  -Arun
