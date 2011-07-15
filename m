Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab1GOP5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 11:57:34 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58030 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab1GOP5d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 11:57:33 -0400
MIME-Version: 1.0
In-Reply-To: <1310744914.7582.36.camel@Joe-Laptop>
References: <cover.1310657068.git.jbaron@redhat.com> <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com> <1310744914.7582.36.camel@Joe-Laptop>
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 15 Jul 2011 17:57:11 +0200
X-Google-Sender-Auth: efn-Kx7KnzIrxgvtnVy2E6tWu6Q
Message-ID: <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
Subject: Re: [PATCH 11/11] dynamic_debug: use a single printk() to emit msgs
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@redhat.com>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 5:48 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2011-07-15 at 12:05 +0200, Bart Van Assche wrote:
>> Not that's it important, but this change makes is possible to
>> eliminate the tid[] and lineno[] arrays again. Has that been
>> considered ?
>
> tid and lineno are decimal.  Not using intermediate
> arrays would require awkward contortions to snprintf
> them without emitting 0 in the output.

Sorry, but I do not agree with the above. The current implementation
of __dynamic_pr_debug() shows that an implementation without temporary
arrays does not require any awkward constructs. See e.g.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=lib/dynamic_debug.c
for the source code of the current implementation of
__dynamic_pr_debug().

This may be subjective, but my opinion is that following that style
results in shorter and more elegant code than the approach with the
temporary arrays proposed in patch 11/11.

Bart.
