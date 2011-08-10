Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab1HJMZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 08:25:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60700 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1HJMZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 08:25:17 -0400
MIME-Version: 1.0
In-Reply-To: <877h6l7hoj.fsf@skywalker.in.ibm.com>
References: <1312200884-20110-1-git-send-email-ajray@ncsu.edu> <877h6l7hoj.fsf@skywalker.in.ibm.com>
From: Eric Van Hensbergen <ericvh@gmail.com>
Date: Wed, 10 Aug 2011 07:24:56 -0500
Message-ID: <CAFkjPT=y4jJTNEFrJLr=i9UVHfixqqGmYbVZf0B4AHk-AmOJdA@mail.gmail.com>
Subject: Re: [PATCH] 9p: remove CONFIG_NET_9P_DEBUG option
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alex Ray <alexjray.ncsu@gmail.com>, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Ray <ajray@ncsu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 4:13 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
>
> On Mon,  1 Aug 2011 07:14:44 -0500, Alex Ray <alexjray.ncsu@gmail.com> wrote:
>> Remove the CONFIG_NET_9P_DEBUG option, used to completely remove logging
>> functionality from v9fs.  Logging is (already) controlled with the
>> run-time debug= option, this gets rid of the compile-time option (which
>> was being misunderstood and misused).
>>
>> Signed-off-by: Alex Ray <ajray@ncsu.edu>
>
> I see this merged to for-next.  Do we know whether enabling debug always have a
> performance impact ?.
>

No clue, but without any debug it makes it impossible for user's to
generate reasonable bug reports.  If I understand the tracepoint
collection facility correctly, it incurs exactly the same overhead as
a DPRINT when the debug mount option is set to 0 (although tracepoints
are much lower overhead when actually collecting).  Now, one could
make a case that we have too many DPRINT and need to cut back, but if
that's the case, let's just get around to it and cleanup a bit.

All that being said, I welcome anyone to send me performance with and
without CONFIG_NET_9P_DEBUG turned on to convince me differently.

        -eric
