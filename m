Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab1BWAb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 19:31:29 -0500
Received: from tango.0pointer.de ([85.214.72.216]:56264 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1BWAb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 19:31:28 -0500
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 19:31:27 EST
Date: Wed, 23 Feb 2011 01:23:13 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] tty: add TIOCVHANGUP: time for revoke() in f_ops ?
Message-ID: <20110223002313.GA21518@tango.0pointer.de>
References: <1297964368.2165.1.camel@yio>
 <20110218095048.4e9f1e1a@lxorguk.ukuu.org.uk>
 <20110222231536.GA18066@kroah.com>
 <20110223000958.7c18fdef@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223000958.7c18fdef@lxorguk.ukuu.org.uk>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23.02.11 00:09, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

> It's basically 3 things
> - Lennarts bits for vhangup on an fd

Uh? Me? I didn't write this patch.

(Though I do like to see patch merged and I would use it, and I have
trouble following your logic.)

vhangup() is different from revoke(). vhangup() does weird SIGHUP
handling and stuff, which I think goes way beyond what revoke() would
eventually do. And that different behaviour becomes visible in various
smaller places. e.g. vhangup() results in POLLHUP on the fd, although I
assume that revoke() would more likely result in POLLERR. And there's
more... Let's not pretend this is really the same thing, because it
isn't.

> Its not a quick patch - that's why its not happened yet, vhangup(fd)
> quickfix Lennart style is unfortunately a useless bodge job which like
> most bodge jobs is simply going to spring leaks and need fixing again.

Thanks. If you are trying to insult me, doesn't really work, because I
didn't do this "bodge job". I'll take it as a compliment though that
you say there's a "Lennart style".

Lennart, style icon

-- 
Lennart Poettering - Red Hat, Inc.
