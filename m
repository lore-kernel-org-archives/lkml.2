Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770Ab2DFJyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 05:54:20 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58315 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782Ab2DFJyT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 05:54:19 -0400
MIME-Version: 1.0
In-Reply-To: <4F78D0BA.9040709@zytor.com>
References: <20120401125741.GA7484@p183.telecom.by>
	<4F78D0BA.9040709@zytor.com>
Date: Fri, 6 Apr 2012 12:54:18 +0300
Message-ID: <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
Subject: Re: [PATCH] nextfd(2)
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 2, 2012 at 1:03 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/01/2012 05:57 AM, Alexey Dobriyan wrote:
>>
>> * /proc/self/fd is unreliable:
>>   proc may be unconfigured or not mounted at expected place.
>>   Looking at /proc/self/fd requires opening directory
>>   which may not be available due to malicious rlimit drop or ENOMEM situations.
>>   Not opening directory is equivalent to dumb close(2) loop except slower.
>>
>
> This is really the motivation for this... the real question is how much
> functionality is actually available in the system without /proc mounted,
> and in particular if this particular subcase is worth optimizing ...

I agree, this particular changelog may be somewhat out of line.

But I find it little hypocritical that kernel developers add CONFIG_PROC_FS,
fix compilation problems associated with it, do not mount proc by default,
do not mark it unmountable somehow and
then say procless setups aren't worth it.

I haven't seen personally procless environments
but several people mentioned them including on this very list.

Without proc knowledge about fdtable is gathered linearly and still unreliable.
With nextfd(2), even procful environments could lose several failure branches.
And they can keep old dumb fd++ or smart /proc/self/fd loops for a change.
