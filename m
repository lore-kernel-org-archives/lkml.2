Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2DAWEN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 18:04:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46287 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab2DAWDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 18:03:48 -0400
Message-ID: <4F78D0BA.9040709@zytor.com>
Date: Sun, 01 Apr 2012 15:03:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by>
In-Reply-To: <20120401125741.GA7484@p183.telecom.by>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2012 05:57 AM, Alexey Dobriyan wrote:
> 
> * /proc/self/fd is unreliable:
>   proc may be unconfigured or not mounted at expected place.
>   Looking at /proc/self/fd requires opening directory
>   which may not be available due to malicious rlimit drop or ENOMEM situations.
>   Not opening directory is equivalent to dumb close(2) loop except slower.
> 

This is really the motivation for this... the real question is how much
functionality is actually available in the system without /proc mounted,
and in particular if this particular subcase is worth optimizing ...
after all, if someone is maliciously setting rlimit, we can just abort
(if someone can set an rlimit they can also force an abort) or revert to
the slow path.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

