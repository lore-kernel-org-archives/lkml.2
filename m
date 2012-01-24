Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2AXAOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:14:16 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:65364 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315Ab2AXAOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:14:12 -0500
MIME-Version: 1.0
In-Reply-To: <20120124000517.GA28878@sergelap>
References: <20120124000517.GA28878@sergelap>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 16:13:49 -0800
X-Google-Sender-Auth: 3iziQua8EVxMRkDW-JjoG8OgGoc
Message-ID: <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
Subject: Re: [RFC] fix devpts mount behavior
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Dave Hansen <haveblue@us.ibm.com>, sukadev@linux.vnet.ibm.com,
        Andy Whitcroft <apw@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Matt Helsley <matthltc@us.ibm.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 4:05 PM, Serge Hallyn
<serge.hallyn@canonical.com> wrote:
>
> I've been playing for the last week with ways to fix this, and in the
> end I can see two ways.

How about a third way:

 - make "newinstance" mandatory (and "-o newinstance" is a no-op) and
forget about the whole issue.

 - if you really want to remount the old global one, you have to use a
bind mount of that original mount instead.

There may be some subtle reason why the above is totally broken and
just fundamnetally wouldn't work, and breaks all existing setups, but
maybe it's worth at least discussing as an option?

Or did I entirely misunderstand the problem?

                      Linus
