Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1GUQYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:24:41 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53960 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189Ab1GUQYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:24:40 -0400
Message-ID: <4E2852C3.50109@gmail.com>
Date: Thu, 21 Jul 2011 10:24:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, stable@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf tools, x86: Fix 32-bit compile on 64-bit
 system
References: <1310420304-21452-1-git-send-email-dsahern@gmail.com> <tip-08a4a43fc407d780bdde36d98f89c0dbb2a6be6b@git.kernel.org> <4E284EAB.1020906@zytor.com>
In-Reply-To: <4E284EAB.1020906@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 10:07 AM, H. Peter Anvin wrote:
>> The problem is the detection of the host arch without considering passed in
>> flags. This change fixes 32-bit builds via:
>>
>> make EXTRA_CFLAGS=-m32
>>
>> and 64-bit builds still reference the memcpy_64.S.
>>
> 
> But this is the wrong way to build 32-bit code on 64-bit platforms.
> make ARCH=i386 is the supported way.
> 
> 	-hpa
> 

Indeed that works fine. If that is the preferred route then the patch
needs to update the following comment in the Makefile:

# Define EXTRA_CFLAGS=-m64 or EXTRA_CFLAGS=-m32 as appropriate for
cross-builds.

to specify ARCH on the command line.

David
