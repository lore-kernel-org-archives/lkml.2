Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab2ASDna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 22:43:30 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43990 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032Ab2ASDn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 22:43:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120118214051.GC20576@boyd>
References: <12011815300568720b5d1587bb777fed0d5b016f0854@nudt.edu.cn>
 <4F16E4BC.5080100@gmail.com> <20120118214051.GC20576@boyd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 18 Jan 2012 19:43:06 -0800
X-Google-Sender-Auth: GTsCpxLLxn6iDbwP2RpuBfG5p9s
Message-ID: <CA+55aFwYufaD_vqwEvfPrfj6wVh9c80BNi3+qziV=qStVxN=3w@mail.gmail.com>
Subject: Re: [PATCH] eCryptfs: infinite loop bug
To: Tyler Hicks <tyhicks@canonical.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Li Wang <liwang@nudt.edu.cn>,
        ecryptfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dustin Kirkland <kirkland@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 1:40 PM, Tyler Hicks <tyhicks@canonical.com> wrote:
>
> mm/filemap.c uses unsigned long for variables used to identify an offset
> into a single page. That's what I'm tempted to use for offset_in_page,
> rather than loff_t.

Indeed. The offset within a page will fit fine even in an "unsigned
int", and "loff_t" is crazy overkill - and usually generates horrible
code on 32-bit architectures.

                      Linus
