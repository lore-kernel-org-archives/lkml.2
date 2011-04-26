Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1DZIzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 04:55:22 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63652 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab1DZIzU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 04:55:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dUBUNnBMH0vg1gsuaBUtY13ze28r/mlCidIPSepZH8f9oTR+WJbShQ1p4AYFbnL+y0
         nxpLoAQ/l/7o4FPTrsUX+OkbeTJR9+OlZ568NRyqudLJE7AavYV59XBWS1io+0qktiIK
         5cdlfSEafl5h6E51snxSZEEPiRK9BRCgJ2TWY=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1104252048190.6978@sister.anvils>
References: <1303086002-6961-1-git-send-email-bookjovi@gmail.com>
	<alpine.LSU.2.00.1104252048190.6978@sister.anvils>
Date: Tue, 26 Apr 2011 16:55:19 +0800
Message-ID: <BANLkTi=92cJNdvmjpKkYZk_Q2XvzXjnbCw@mail.gmail.com>
Subject: Re: [PATCH] proc: put check_mem_permission before __get_free_page in mem_read
From: Jovi Zhang <bookjovi@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 11:56 AM, Hugh Dickins <hughd@google.com> wrote:
> On Sun, 17 Apr 2011, bookjovi@gmail.com wrote:
>> From: Jovi Zhang <bookjovi@gmail.com>
>>
>> It should be better if put check_mem_permission before __get_free_page
>> in mem_read, to be same as function mem_write.
>>
>> Signed-off-by: Jovi Zhang <bookjovi@gmail.com>
>
> Sorry to be contrary, but I disagree with this.  I'm all for consistency,
> but is there a particular reason why you think the mem_write ordering is
> right and mem_read wrong?
>
> My reason for preferring the current mem_read ordering is this:
>
> check_mem_permission gets a reference to the mm.  If we __get_free_page
> after check_mem_permission, imagine what happens if the system is out
> of memory, and the mm we're looking at is selected for killing by the
> OOM killer: while we wait in __get_free_page for more memory, no memory
> is freed from the selected mm because it cannot reach exit_mmap while
> we hold that reference.
>
> (I may be overstating the case: a little memory may be freed from the
> exiting task's stack, and kswapd should still be able to pick some pages
> off the mm.  But nonetheless, we would do better to let this mm go.)
>

Indeed, I missed that point. Thanks.
