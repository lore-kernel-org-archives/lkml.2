Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab0LANUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 08:20:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50199 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab0LANUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 08:20:32 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com>
References: <AANLkTik_TQfQDERdRQaQek3S7280sQBmHGKOnhJwU5EE@mail.gmail.com>
Date: Wed, 1 Dec 2010 13:20:30 +0000
X-Google-Sender-Auth: iVjtB_NcQ-GxlgZUjk3wS8BGUNo
Message-ID: <AANLkTim=srU8kv-DwL4jgwRS-yH8WN34PgCqsijZvYeV@mail.gmail.com>
Subject: Re: Problems using EXPORT_SYMBOL with lib/flex_array
From: Alex Bennee <kernel-hacker@bennee.com>
To: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 December 2010 12:05, Alex Bennee <kernel-hacker@bennee.com> wrote:
> Hi,
>
> I want to be able to use the flex_array functions in my module so I
> wanted to EXPORT_SYMBOL the API.
> <snip>
> Am I being a
> little dim or is there some other magic foo that needs doing to add an
> export to a library function?

It turns out for library code there is. If the .o is only included in
the lib-y section then it will never get scanned for exported kernel
symbols. Tweaking the lib/Makefile so obj-y included flex_array.o did
the trick.

I'm unsure if this behaviour is what is wanted?

-- 
Alex, homepage: http://www.bennee.com/~alex/
http://www.half-llama.co.uk
