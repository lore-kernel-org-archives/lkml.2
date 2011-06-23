Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab1FWTjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 15:39:07 -0400
Received: from outmail008.snc4.facebook.com ([66.220.144.140]:64019 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932702Ab1FWTjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 15:39:05 -0400
Message-ID: <4E03968A.5010008@fb.com>
Date: Thu, 23 Jun 2011 12:39:54 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Using a new perf tool against an older kernel
References: <4E026123.4060208@fb.com> <4E034C2C.30509@gmail.com>
In-Reply-To: <4E034C2C.30509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/11 7:22 AM, David Ahern wrote:

> I have not seen issues like this using newer perf userspace against
> older kernels. For example, my laptop was running Fedora 14 (2.6.35) and
> now Fedora 15 (2.6.38.8) and I typically use latest perf builds (e.g.,
> testing patches).

I narrowed it down to PERF_SAMPLE_RAW:

perf record -ag -- sleep 1

is fine, but:

perf record -agR -- sleep 1

fails for me most of the time. The reason I needed to use the -R in the 
first place is that "perf script" fails on older kernels with:

Samples do not contain timestamps.

With the newer perf, I don't get errors, but the timestamp field is 
invalid. So I need to use the -R flag to get valid timestamps + 
stacktraces out of "perf script".

  -Arun
