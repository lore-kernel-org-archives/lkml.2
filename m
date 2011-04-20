Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1DTLt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 07:49:26 -0400
Received: from mx04.teleca.com ([212.92.145.6]:36523 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525Ab1DTLtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 07:49:25 -0400
Message-ID: <4DAEC8BB.9040809@nokia.com>
Date: Wed, 20 Apr 2011 15:51:23 +0400
From: Roman Borisov <ext-roman.borisov@nokia.com>
MIME-Version: 1.0
To: ext Andrew Morton <akpm@linux-foundation.org>
CC: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        vda.linux@googlemail.com, cebbert@redhat.com, virtuoso@slind.org
Subject: Re: [PATCH] fs: bound mount propagation fix
References: <201103262243.18031.vda.linux@googlemail.com>	<7b9aa806294aadd47704d56ae3e7c757bf0ce6db.1301667509.git.ext-roman.borisov@nokia.com> <20110419140400.23367a16.akpm@linux-foundation.org>
In-Reply-To: <20110419140400.23367a16.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Apr 2011 11:49:23.0476 (UTC) FILETIME=[FE0A8540:01CBFF50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 01:04 AM, ext Andrew Morton wrote:
> On Fri,  1 Apr 2011 18:48:20 +0400
> Roman Borisov<ext-roman.borisov@nokia.com>  wrote:
>
>> I think MS_SILENT shouldn't be cleared anywhere. I suppose the bug is in
>> MS_SHARED options checking. Please see the patch below.
>>
>> Fixed MS_SHARED, MS_SLAVE, MS_UNBINDABLE option handling;
>> Existing options check doesn't allow to have any options combinations
>> because of integer comparison (not bitwise).
>>
>
> (when fixing a bug, please include a *complete* description of that bug
> in the changelog.  It should include a description of the user-visible
> misbehaviour and a description of the coding error).
>
>
> The vfs code is pretty confusing about whether `type' is supposed to be
> a scalar or a bitfield.
>
> flags_to_propagation_type() has that is_power_of-two() check in there
> to reject more-than-one-bit-set.
>

Thanks for comment.
I tested the patch on too old kernel which doesn't contain is_power_of_2 
checking in do_change_type.
I'll post patch_v2 recently.

--
Roman
