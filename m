Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab2BWO5B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 09:57:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56045 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab2BWO5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 09:57:00 -0500
Message-ID: <4F4653B2.6000306@zytor.com>
Date: Thu, 23 Feb 2012 06:56:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Bobby Powers <bobbypowers@gmail.com>
CC: linux-kernel@vger.kernel.org, dhowells@redhat.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH tip/x86/x32] fs: fix close_on_exec pointer in alloc_fdtable
References: <1329888587-3087-1-git-send-email-bobbypowers@gmail.com> <1986.1329905936@redhat.com> <CAArOQ2U5CUiZ++RQdaB_AZSWKof4BM1Sbr=GihMRbH-kj_DGAQ@mail.gmail.com>
In-Reply-To: <CAArOQ2U5CUiZ++RQdaB_AZSWKof4BM1Sbr=GihMRbH-kj_DGAQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2012 06:40 AM, Bobby Powers wrote:
> On Wed, Feb 22, 2012 at 5:18 AM, David Howells<dhowells@redhat.com>  wrote:
>> Bobby Powers<bobbypowers@gmail.com>  wrote:
>>
>>> alloc_fdtable allocates space for the open_fds and close_on_exec
>>> bitfields together, as 2 * nr / BITS_PER_BYTE.  close_on_exec needs to
>>> point to open_fds + nr / BITS_PER_BYTE, not open_fds + nr /
>>> BITS_PER_LONG, as introducted in 1fd36adc: Replace the fd_sets in
>>> struct fdtable with an array of unsigned longs.
>>>
>>> Signed-off-by: Bobby Powers<bobbypowers@gmail.com>
>>
>> Yes, you're right.  At one point I changed data to be an unsigned long *.
>>
>> Acked-by: David Howells<dhowells@redhat.com>
>
> Thanks, its nice to have confirmation - I'm still pretty new at this.
> Can this get pulled onto tip/x86/x32?  Desktop applications like
> firefox and chrome don't work reliably without it.
>

tip:core/types (and the updated core/types needs to be merged into 
x86/x32) but yes.

	-hpa
