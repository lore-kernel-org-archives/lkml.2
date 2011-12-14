Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361Ab1LNXz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:55:58 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:33295 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1LNXz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:55:56 -0500
MIME-Version: 1.0
In-Reply-To: <20111214114016.9441.12006.stgit@warthog.procyon.org.uk>
References: <20111214114016.9441.12006.stgit@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 14 Dec 2011 15:55:34 -0800
X-Google-Sender-Auth: LSpojl4aWtWgYjgaRdasz2cH9M4
Message-ID: <CA+55aFxEszjub9-MJD0irFs8y3hzGe3Ph=7RqWfkJ-0jKFtCeA@mail.gmail.com>
Subject: Re: [PATCH] Fix order_base_2(0)
To: David Howells <dhowells@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        "Robert P. J. Day" <rpjday@crashcourse.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 3:40 AM, David Howells <dhowells@redhat.com> wrote:
> The order_base_2() function is either wrongly documented or wrongly
> implemented.  In the preceding comment, it says that:
>
>        ob2(0) = 0

Let's just remove that comment. That's just crazy math and makes no
sense. Why would anybody do ilog2() on zero and expect anything valid?

At least "-1" would make a tiny amount as sense as an error return or
"underflow" or whatever. But returning 0 is just wrong. That's
ilog2(1), not 0.

Does anybody actually *want* order_base_2(0)?

                      Linus
