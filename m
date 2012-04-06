Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2DFQXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 12:23:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44194 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753936Ab2DFQXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 12:23:07 -0400
Message-ID: <4F7F1864.8090606@zytor.com>
Date: Fri, 06 Apr 2012 09:23:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, drepper@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] nextfd(2)
References: <20120401125741.GA7484@p183.telecom.by> <4F78D0BA.9040709@zytor.com> <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
In-Reply-To: <CACVxJT_WJYjecpZMGkyUrbE5gNROX1tOfFAcD84-hoPsypxcFQ@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2012 02:54 AM, Alexey Dobriyan wrote:
> 
> Without proc knowledge about fdtable is gathered linearly and still unreliable.
> With nextfd(2), even procful environments could lose several failure branches.
> And they can keep old dumb fd++ or smart /proc/self/fd loops for a change.
> 

Incidentally, if we were to create a system call for this -- which I so
far see no reason for -- I would make it return a select-style bitmask
of file descriptors in use, not a "next fd" which would require a system
call per iteration.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

