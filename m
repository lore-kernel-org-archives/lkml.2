Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2GaPte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:49:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58233 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623Ab2GaPtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:49:32 -0400
Message-ID: <5017FE81.3080903@zytor.com>
Date: Tue, 31 Jul 2012 08:49:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, x86@kernel.org
Subject: Re: [PATCH] extend_brk and fixes to users of extend_brk (v1).
References: <1343731376-20658-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1343731376-20658-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 03:42 AM, Konrad Rzeszutek Wilk wrote:
>
>   [PATCH 3/3] x86: Let extend_brk return a NULL pointer instead of
>
> makes extend_brk not do BUG_ON and instead just return NULL. This allows
> us to handle the bootup issues more gracefully.
>

NAK.  The whole point of the brk allocator is that users specify the 
upper limit on what they may need and stick to it.  Hence it is a fatal 
code bug if that is ever exceeded.  We want to catch those errors, not 
"handle" them.

This means you're either abusing the brk allocator to do something it is 
not meant to do... which may mean you can a failure in *other* code, or 
you have a bug in your code that you haven't fixed.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

