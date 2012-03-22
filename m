Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759890Ab2CVUwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:52:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45576 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759824Ab2CVUwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:52:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120322204400.GD6589@ZenIV.linux.org.uk>
References: <20120322183845.GA17264@phenom.dumpdata.com> <20120322200918.GZ6589@ZenIV.linux.org.uk>
 <20120322202445.GB6589@ZenIV.linux.org.uk> <CA+55aFyiNKdkkvK0FH1ibo1iJj1HF9RjLEw3VOEjVwc0eiX8Sw@mail.gmail.com>
 <20120322204400.GD6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Mar 2012 13:52:14 -0700
X-Google-Sender-Auth: trBZ3BpwlSJ8tLxCIVz1BdOmLMk
Message-ID: <CA+55aFzkr4p+AaQ0udqhSGpVKS-s9V2v4K4JkMzCYsNj+oCLow@mail.gmail.com>
Subject: Re: Regression introduced by bfcfaa77bdf0f775263e906015982a608df01c76
 (vfs: use 'unsigned long' accesses for dcache name comparison and hashing)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 1:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> See upthread for diff doing just that ;-)  Let's see if that fixes the
> crap guys are seeing...  BTW, you have used full_name_hash(), just not
> on something 8 char long - devpts uses d_alloc_name(), but pty numbers
> tend to be less than ten millions...

Moving the "*=9" down to the "next" iteration does fix it for me in my
user-space test I just whipped up. Not exhaustive, but  at least the
test confirms the thinking.

But yeah, let's verify that it also fixes the actual problem being reported.

And you're right, I don't have ten million pty's ;)

                        Linus
