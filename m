Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab1JIKTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 06:19:51 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:42570 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab1JIKTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 06:19:50 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
Date: Sun, 09 Oct 2011 21:19:35 +1100
From: "Bojan Smojver" <bojan@rexursive.com>
To: penberg@cs.helsinki.fi
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
MIME-Version: 1.0
X-Mailer: LCG ProfiMail 3.48
Message-ID: <6127211897.1002662375@rexursive.com>
References: <1317342456.1959.6.camel@shrek.rexursive.com> <3169978091.1002283638@rexursive.com> <201110062037.14322.rjw@sisk.pl> <201110062045.48689.rjw@sisk.pl> <CAOJsxLE7uRFv6FXsz+czLO3+VjDtT-QgHVRZEpZwBJJF0B3ahw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------- Original message -------
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> To: rjw@sisk.pl
> Cc: bojan@rexursive.com, linux-kernel@vger.kernel.org, 
> linux-pm@lists.linux-foundation.org
> Sent: 9.10.'11,  20:22
>
> On Thu, Oct 6, 2011 at 9:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> The panic happens during late resume, when trying to switch to the 
>> hibernated
>> kernel.
>
> Is there some way to autotest hibernation? I could try to reproduce
> the issue but I'm certainly not going to hibernate/resume by hand...
> :-)

I kinda remember reading in one of the bug reports for Intel graphics about 
someone doing it. Not sure how, to be honest. Rafael will know for sure.

May be related, when I simulate image loading failure by returning error 
from load_image(), I get bad page state error, count -1, so something is 
amiss. Probably the readahead buffers or maps.

PS. I will also rewrite some of the vmalloc() calls to kmalloc(). No point 
wasting whole pages for small objects.

--
Bojan 
