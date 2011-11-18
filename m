Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab1KRHcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 02:32:17 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35552 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab1KRHcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 02:32:16 -0500
Message-ID: <4EC609FC.7000601@openvz.org>
Date: Fri, 18 Nov 2011 11:32:12 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20111010 Iceape/2.0.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] mm: account reaped page cache on inode cache pruning
References: <20111116134713.8933.34389.stgit@zurg>	<20111117162322.1c3e3d05.akpm@linux-foundation.org>	<4EC5FE6A.3080003@openvz.org> <20111117225202.3535aba3.akpm@linux-foundation.org>
In-Reply-To: <20111117225202.3535aba3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 18 Nov 2011 10:42:50 +0400 Konstantin Khlebnikov<khlebnikov@openvz.org>  wrote:
>
>> Do we really need separate on-stack reclaim_state structure with single field?
>> Maybe replace it with single long (or even unsigned int) .reclaimed_pages field on task_struct
>> and account reclaimed pages unconditionally.
>
> I don't think it matters a lot - it's either a temporary pointer on the
> stack or a permanent space consumption in the task_struct.

Yes, but currently task_struct has permanent pointer to reclaim_state =)

>
> The way thing are at present we can easily add new fields if needed.  I
> don't think we've ever done that though.

