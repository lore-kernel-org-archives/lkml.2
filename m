Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab1GOQK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:10:59 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38876 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab1GOQK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:10:58 -0400
MIME-Version: 1.0
In-Reply-To: <20110715160417.GB2493@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com> <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
 <1310744914.7582.36.camel@Joe-Laptop> <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
 <20110715160417.GB2493@redhat.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 15 Jul 2011 18:10:37 +0200
X-Google-Sender-Auth: OyhUQscW4XyVi2HKYAW6IbM4NBs
Message-ID: <CAO+b5-qgrV=gfZAczxfPbGqVtv4ZD_zZHOn-BMVY9wnJytbrtw@mail.gmail.com>
Subject: Re: [PATCH 11/11] dynamic_debug: use a single printk() to emit msgs
To: Jason Baron <jbaron@redhat.com>
Cc: Joe Perches <joe@perches.com>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 6:04 PM, Jason Baron <jbaron@redhat.com> wrote:
> yes, but that approach uses 'KERN_CONT'. The point of patch 11/11 is to get rid
> of KERN_CONT, which is racy.

I know. What I'm trying to explain is that since patch 11/11 modifies
dynamic_emit_prefix() such that it writes its output to a buffer there
is no longer a need to write into that buffer with a single snprintf()
call. Using multiple snprintf() calls is also fine. Hence it is
possible to eliminate the two temporary arrays (tid[] and lineno[])
from dynamic_emit_prefix() without reintroducing these races.

Bart.
