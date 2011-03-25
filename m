Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab1CYXMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 19:12:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58829 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab1CYXMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 19:12:42 -0400
MIME-Version: 1.0
In-Reply-To: <20110325090210.GA5860@polaris.bitmath.org>
References: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
 <1300842244-42723-4-git-send-email-jeffbrown@android.com> <20110325090210.GA5860@polaris.bitmath.org>
From: Jeffrey Brown <jeffbrown@android.com>
Date: Fri, 25 Mar 2011 16:12:01 -0700
Message-ID: <AANLkTinqbLShaVGL6NJCMamHNWzMGT7DLXb7OQ6dxLVX@mail.gmail.com>
Subject: Re: [PATCH 3/4] input: evdev: Indicate buffer overrun with SYN_DROPPED.
To: Henrik Rydberg <rydberg@euromail.se>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Fri, Mar 25, 2011 at 2:02 AM, Henrik Rydberg <rydberg@euromail.se> wrote:
> My last comment was not right, the SYN_DROPPED is pushed ahead in the
> buffer, sorry about that. However, this change does not shrink the
> number of buffered elements in case of an overrun, which has been
> discussed before as a possibly important feature of the current
> code. I would be more comfortable prepending the head with a
> SYN_DROPPED, like this:
>
> if (client->head == client->tail) {
>        struct input_event drop;
>
>        drop.time = event->time;
>        drop.type = EV_SYN;
>        drop.code = SYN_DROPPED;
>        drop.value = 0;
>        client->buffer[client->head++] = drop;
>        client->head &= client->bufsize - 1;
>
>        client->buffer[client->head++] = *event;
>        client->head &= client->bufsize - 1;
> }
>
> The main point is that if we end up having to drop an event, it is
> likely we will have to drop the next one, too.

I think that's a good idea.  If the client is far behind then we might
as well truncate the buffer as you suggest.  I'll do that.

Jeff.
