Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2HMVBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 17:01:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35574 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab2HMVBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 17:01:51 -0400
Message-ID: <50296B34.8090502@zytor.com>
Date: Mon, 13 Aug 2012 14:01:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: David Cullen <David.Cullen@koe-americas.com>
CC: Michal Marek <mmarek@suse.cz>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] Fix "/usr/bin/xargs: rm: Argument list too long"
 during make distclean
References: <502957D5.1070800@koe-americas.com> <502965BE.3070406@zytor.com> <502969FA.6010907@koe-americas.com>
In-Reply-To: <502969FA.6010907@koe-americas.com>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 01:56 PM, David Cullen wrote:
>>
>> That sounds like a bug in xargs...
>>
> 
> In my specific case, qemu-arm-static calls xargs (In fact, in my
> cross chroot, qemu-arm-static is used to run every user mode process).
> 
> Do you mean that qemu-arm-static is exposing a latent defect in xargs?
> 
> Does qemu-arm-static steal some of the command line space that would
> normally be available for xargs? If so, how would xargs figure out
> this was happening and handle the problem?
> 

I have no idea.  Perhaps strace can help you see what is happening, I
don't know.  More likely it is qemu-arm-static that is broken and it is
trying to enforce the old 128K limit that we used to have before 2.6.23.
 This could cause a mismatch between what sysconf(_SC_ARG_MAX) returns
and what the actual limit is.

Anyway, even more so the reason to reject this patch.

	-hpa
