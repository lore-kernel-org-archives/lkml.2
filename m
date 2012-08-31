Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab2HaPYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 11:24:34 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47013 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab2HaPYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 11:24:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120830150348.287bfa2f.akpm@linux-foundation.org>
References: <503e0dde.ssYktQsJ5nYlhlQB%paul.clements@steeleye.com>
	<20120830150348.287bfa2f.akpm@linux-foundation.org>
Date: Fri, 31 Aug 2012 11:24:31 -0400
Message-ID: <CAECXXi7viVEV9eeZ-LvE-wRTDe_r76=1iWffMNPeG1c-Gx5=bA@mail.gmail.com>
Subject: Re: [PATCH 2/2] [RESEND] add discard support to nbd
From: Paul Clements <paul.clements@us.sios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 6:03 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 29 Aug 2012 08:41:02 -0400
> paul.clements@steeleye.com wrote:
>
>> Description: This patch adds discard support to nbd. When the nbd client
>> system receives a discard request, this will be passed along to the nbd
>> server system, where the nbd-server will respond by performing:
>>       fallocate(.. FALLOC_FL_PUNCH_HOLE ..)
>>
>> To punch a hole in the backend storage, which is no longer needed.
>>
>
> What happens if the user is running an older server?

In that case, the older server will not have set NBD_SEND_FLAG_TRIM,
so QUEUE_FLAG_DISCARD doesn't get set, so no discards will be sent to
the device.

> I is it possible that because the old server didn't set
> NBD_FLAG_SEND_TRIM, the user's screen gets filled with WARN_ONs?

No.

> Anyway, please make sure this combination was tested!

It was.

Thanks for the feedback.

I will resend v2 of the patches shortly.

--
Paul
