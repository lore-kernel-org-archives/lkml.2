Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab2DRA4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 20:56:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54353 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2DRA4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 20:56:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120417234423.GY6589@ZenIV.linux.org.uk>
References: <20120417052511.GU6589@ZenIV.linux.org.uk> <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417180129.GW6589@ZenIV.linux.org.uk> <20120417182825.GX6589@ZenIV.linux.org.uk>
 <20120417211419.GC27426@fieldses.org> <CA+55aFwdh_QWG-R2FQ71kDXiNYZ04qPANBsY_PssVUwEBH4uSw@mail.gmail.com>
 <20120417234423.GY6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Apr 2012 17:56:24 -0700
X-Google-Sender-Auth: _dimqcQIXhBtd48_XJbwBBEm3JQ
Message-ID: <CA+55aFw4ZUvqLKtNTrwfsXx0bVmgHWH+6BDeXGa4+EGY1xYQQw@mail.gmail.com>
Subject: Re: [git pull] vfs and fs fixes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 4:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> In principle, yes, but have you tried to grep for i_mutex?

No, I hadn't, and right you are. That's a mess.

It's not the i_mutex hits themselves that look scary, but there's 75
hits on just the *nested* locking. That's way more than I would have
guessed without the grep.

The ext4 ones look pretty simple. But yeah, there's a lot of other
noise there...

                    Linus
