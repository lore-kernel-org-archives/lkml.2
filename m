Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab2BPQWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:22:13 -0500
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:46470 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752425Ab2BPQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:22:11 -0500
Message-ID: <4F3D2D30.8070403@akamai.com>
Date: Thu, 16 Feb 2012 10:22:08 -0600
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2] compat: poll() in 32-bit applications does not
 handle negative timeout values properly on 64-bit kernels
References: <4F3602A9.3060206@akamai.com> <1328975240.5661.31.camel@edumazet-laptop>
In-Reply-To: <1328975240.5661.31.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2012 09:47 AM, Eric Dumazet wrote:
> Le vendredi 10 février 2012 à 23:54 -0600, Josh Hunt a écrit :
>> We have hit an issue where our 32-bit applications using poll() and
>> passing in a value of -1 for the timeout value return after ~49 days
>> (2^32 msec), instead of waiting indefinitely. I've instrumented the
>> kernel and found we are hitting the case where poll() believes we've
>> passed in a positive number and thus creates a timespec, etc. I've
>> implemented compat_sys_poll() to sign-extend the timeout value and
>> resolve the issue.
>>
>> There was an almost identical patch submitted last year, but for
>> whatever reason did not make it in:
>> https://lkml.org/lkml/2011/9/18/19
> 
> Probably because Thomas Meyer didnt answer to patch reviewers, and not
> enough people cared.
> 
> By the way, an inline patch is better, as stated in
> Documentation/SubmittingPatches
> 
> Anyway, its time to fix this bug...
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> 

I can resubmit the patch inline if you feel that will get more attention
by whoever needs to do the final approval on this.

Josh


