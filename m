Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab1G0Ocq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 10:32:46 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63890 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292Ab1G0Oco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 10:32:44 -0400
MIME-Version: 1.0
In-Reply-To: <201107271628.29532.arnd@arndb.de>
References: <CAFbHwiQaYeQSwRykhKp57rQ8xLKSst9MXF7YJoQjEm0V+WN4Qw@mail.gmail.com>
	<201107271455.39511.arnd@arndb.de>
	<CAFbHwiSkqpRUv2CW8sqL8XQEkbbvtos2h5UTTX19jeXJNrBOUA@mail.gmail.com>
	<201107271628.29532.arnd@arndb.de>
Date: Wed, 27 Jul 2011 15:32:43 +0100
Message-ID: <CAFbHwiRUKEuK_88+yfUpiWnRBgGKBTpH2Fm7EpzW-dJSiwhHLA@mail.gmail.com>
Subject: Re: [PATCH] bitops: Use volatile in generic atomic bitops.
From: Will Newton <will.newton@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 3:28 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 27 July 2011, Will Newton wrote:
>> >
>> > Have you observed this behavior? The interrupt disable/enable should
>> > always come with a barrier that should prevent the bitops from
>> > leaking out, so I don't see how this causes problems in practice.
>>
>> Yes, although my arch does not have these barriers. Now I see from
>> memory-barriers.txt that lock/unlock are required to implement a
>> compiler barrier, sorry for the noise!
>
> Which architectures is this?

Imagination Technologies META, which is a custom in-house
architecture. No immediate plans to upstream unfortunately. :-/

FWIW I checked all the in-tree architectures and it seems everyone
else gets this right (although I got a bit lost with tile).
