Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1C1OwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 10:52:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60740 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab1C1OwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 10:52:20 -0400
Message-ID: <4D90A08D.707@zytor.com>
Date: Mon, 28 Mar 2011 07:51:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        torvalds@linux-foundation.org, rostedt@goodmis.org,
        srostedt@redhat.com, tglx@linutronix.de, adobriyan@gmail.com
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Add comment to explain ({0;})
References: <tip-ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870@git.kernel.org>
In-Reply-To: <tip-ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2011 07:45 AM, tip-bot for Steven Rostedt wrote:
> 
> WARN_ON_SMP(): Add comment to explain ({0;})
> 
> The define to use ({0;}) for the !CONFIG_SMP case of WARN_ON_SMP()
> can be confusing. As the WARN_ON_SMP() needs to be a nop when
> CONFIG_SMP is not set, including all its parameters must not be
> evaluated, and that it must work as both a stand alone statement
> and inside an if condition, we define it to a funky ({0;}).
> 
> A simple "0" will not work as it causes gcc to give the warning that
> the statement has no effect.
> 
> As this strange definition has raised a few eyebrows from some
> major kernel developers, it is wise to document why we create such
> a work of art.
> 

What the heck is wrong with the idiomatic and non-gcc-extension-using:

	((void)0)

?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

