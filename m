Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab1G0NJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:09:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab1G0NJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <201107271455.39511.arnd@arndb.de>
References: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com>
	<201107271455.39511.arnd@arndb.de>
Date: Wed, 27 Jul 2011 14:09:38 +0100
Message-ID: <CAFbHwiSkqpRUv2CW8sqL8XQEkbbvtos2h5UTTX19jeXJNrBOUA@mail.gmail.com>
Subject: Re: [PATCH] bitops: Use volatile in generic atomic bitops.
From: Will Newton <will.newton@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 1:55 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 27 July 2011, Will Newton wrote:
>> The generic atomic bitops currently explicitly cast away the
>> volatile from the pointer passed to them. This will allow the
>> access to the bitfield to happen outside of the critical section
>> thus making the bitops no longer interrupt-safe. Remove this cast
>> and add a volatile keyword to make sure all accesses to the
>> bitfield happen inside the critical section.
>>
>> Signed-off-by: Will Newton <will.newton@imgtec.com>
>
> Have you observed this behavior? The interrupt disable/enable should
> always come with a barrier that should prevent the bitops from
> leaking out, so I don't see how this causes problems in practice.

Yes, although my arch does not have these barriers. Now I see from
memory-barriers.txt that lock/unlock are required to implement a
compiler barrier, sorry for the noise!
