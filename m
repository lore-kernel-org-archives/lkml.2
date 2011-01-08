Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab1AHCRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 21:17:32 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59165 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1AHCRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 21:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=w6rel9K33tafRmkhht9rg8GLOrPFnaDHdY/CyXlam8a6e1hfgAL69MQQKr4zYv/vn6
         +TyAATYi1IeYP2GZr5jL/2pwb7KXDERjrOh4tlh6u8r6fkQIw5V8tj65qVlUGxzkBhJb
         OdqzJdA7YT63kk5NJyfktrhHXh7ygNNEfH+Dk=
MIME-Version: 1.0
In-Reply-To: <AANLkTim75ihzBKXx1e9NbPnECMrKUidOLWjVuBWHwiEP@mail.gmail.com>
References: <AANLkTim75ihzBKXx1e9NbPnECMrKUidOLWjVuBWHwiEP@mail.gmail.com>
Date: Sat, 8 Jan 2011 10:17:29 +0800
Message-ID: <AANLkTinkxPSeWz1jev69quw+Nv+3JG0U6t2WE4cDkuxV@mail.gmail.com>
Subject: Re: [PATCH] replace ida in workqueue with page-sized buffer
From: Hillf Danton <dhillf@gmail.com>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 9:10 PM, Hillf Danton <dhillf@gmail.com> wrote:
> The id of worker of global work queue is monitored with kernel library, ida.
>
> The ida in global work queue is redefined to be page-sized buffer,
> which is allocated when initializing workqueue.
>
> The new id allocator could monitor ids in the rage from 0 to INT_MAX.
> The buffer is used to store freed ids, and if the peak number of ids,
> in workqueue as whole, is not out of the capacity of the allocated
> buffer, there is no more allocation of buffer after initializing.
>
> The advantage looks that the new allocator runs faster.
>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Hey Ingo

Please take a glance at the patch for replacing ida in workqueue at

       https://lkml.org/lkml/2010/12/18/35

thanks
Hillf
