Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab2ESE5r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 00:57:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53862 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab2ESE5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 00:57:44 -0400
MIME-Version: 1.0
In-Reply-To: <1337397553.7562.24.camel@gandalf.stny.rr.com>
References: <1337372991-14783-1-git-send-email-vnagarnaik@google.com>
 <1337392560.7562.21.camel@gandalf.stny.rr.com> <CAL26m8KwqabX1TqOcrVZC1cAFyzbo6fKPB44jcrQfqDytNfANA@mail.gmail.com>
 <1337397553.7562.24.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Fri, 18 May 2012 21:57:12 -0700
Message-ID: <CAL26m8L6-LCYV5mDH=6e6hfmG5KEAHo00zTf+yKU5w1sDB7Pug@mail.gmail.com>
Subject: Re: [PATCH] tracing: Merge separate resize loops
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Laurent Chavey <chavey@google.com>, Justin Teravest <teravest@google.com>,
        David Sharp <dhsharp@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 8:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> But if there were updates on a offline CPU, then the original patch
> would not have set this to zero at the end.

Right.

> Or are you just saying that we don't need to set this to zero, as it
> isn't used later on? And when we re-enter this function (where its the
> only place, and what it calls, that uses nr_page_to_update), it gets
> reset.
>
> IOW, this reset is just a "clean up" of the nr_pages_to_update. Right?

Yes, that's exactly right and a much better way to put it :)

It's just a reset which isn't strictly needed since nr_pages_to_update
gets initialized before it is used and isn't used after resize
operation.


Vaibhav Nagarnaik
