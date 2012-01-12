Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab2ALIPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:15:52 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53320 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758Ab2ALIPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:15:51 -0500
MIME-Version: 1.0
In-Reply-To: <1326355594.1999.7.camel@lappy>
References: <1326300636-29233-1-git-send-email-levinsasha928@gmail.com>
	<20120111141219.271d3a97.akpm@linux-foundation.org>
	<1326355594.1999.7.camel@lappy>
Date: Thu, 12 Jan 2012 10:15:50 +0200
X-Google-Sender-Auth: jclF1ecP_ymeTyaANQosHWyfbAE
Message-ID: <CAOJsxLEYY=ZO8QrxiWL6qAxPzsPpZj3RsF9cXY0Q2L44+sn7JQ@mail.gmail.com>
Subject: Re: [PATCH] mm: Don't warn if memdup_user fails
From: Pekka Enberg <penberg@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lizf@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tyler Hicks <tyhicks@canonical.com>,
        Dustin Kirkland <kirkland@canonical.com>, ecryptfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 10:06 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Let's split it to two parts: the specific ecryptfs issue I've given as
> an example here, and a general view about memdup_user().
>
> I fully agree that in the case of ecryptfs there's a missing validity
> check, and just calling memdup_user() with whatever the user has passed
> to it is wrong and dangerous. This should be fixed in the ecryptfs code
> and I'll send a patch to do that.
>
> The other part, is memdup_user() itself. Kernel warnings are usually
> reserved (AFAIK) to cases where it would be difficult to notify the user
> since it happens in a flow which the user isn't directly responsible
> for.
>
> memdup_user() is always located in path which the user has triggered,
> and is usually almost the first thing we try doing in response to the
> trigger. In those code flows it doesn't make sense to print a kernel
> warnings and taint the kernel, instead we can simply notify the user
> about that error and let him deal with it any way he wants.
>
> There are more reasons kalloc() can show warnings besides just trying to
> allocate too much, and theres no reason to dump kernel warnings when
> it's easier to notify the user.

I think you missed Andrew's point. We absolutely want to issue a
kernel warning here because ecryptfs is misusing the memdup_user()
API. We must not let userspace processes allocate large amounts of
memory arbitrarily.

                        Pekka
