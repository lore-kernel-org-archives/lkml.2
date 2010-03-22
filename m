Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275Ab0CVVC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 17:02:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab0CVVCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 17:02:21 -0400
Message-ID: <4BA7DAB3.5030002@redhat.com>
Date: Mon, 22 Mar 2010 23:01:39 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
       hpa@zytor.com, tglx@linutronix.de, rostedt@goodmis.org,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com,
       mhiramat@redhat.com, fweisbec@gmail.com
Subject: Re: [PATCH 2/5] jump label: base patch
References: <cover.1269272444.git.jbaron@redhat.com> <79304b525d61cb0e7516cdee1ddcdb5ac3f2579a.1269272444.git.jbaron@redhat.com>
In-Reply-To: <79304b525d61cb0e7516cdee1ddcdb5ac3f2579a.1269272444.git.jbaron@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2010 06:07 PM, Jason Baron wrote:
> base patch to implement 'jump labeling'. Based on a new 'asm goto' inline
> assembly gcc mechanism, we can now branch to labels from an 'asm goto'
> statment. This allows us to create a 'no-op' fastpath, which can subsequently
> be patched with a jump to the slowpath code. This is useful for code which
> might be rarely used, but which we'd like to be able to call, if needed.
> Tracepoints are the current usecase that these are being implemented for.
>
>
> +
> +#define JUMP_LABEL(tag, label, cond)		\
> +	if (unlikely(cond))			\
> +		goto label;
>    

Suggest wrapping with do { } while (0) to avoid problems with the 
dangling semicolon or a trailing 'else' from an outer if ().

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

