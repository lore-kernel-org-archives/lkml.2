Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944Ab2KGTcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:32:51 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36607 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab2KGTct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:32:49 -0500
MIME-Version: 1.0
In-Reply-To: <20121107171541.GA24482@redhat.com>
References: <1352247335-10396-1-git-send-email-jwerner@chromium.org>
	<20121107013907.GA31185@redhat.com>
	<CAODwPW-636Sn3B4CYajvrgccXxresZwPLg2UFz6xDDk9-FfTYQ@mail.gmail.com>
	<20121107155434.GA17677@redhat.com>
	<1352305752.3140.4449.camel@edumazet-glaptop>
	<20121107164358.GA20495@redhat.com>
	<1352307902.3140.4588.camel@edumazet-glaptop>
	<20121107171541.GA24482@redhat.com>
Date: Wed, 7 Nov 2012 11:32:47 -0800
X-Google-Sender-Auth: eGKIGcM2LM937G9WTFty965MG9M
Message-ID: <CAODwPW9kiG-jo=n0zedv5KT-8-gJcEUrdC3F2mAEjt78tne18g@mail.gmail.com>
Subject: Re: [PATCH] tcp: Replace infinite loop on recvmsg bug with proper crashusers
From: Julius Werner <jwerner@chromium.org>
To: Dave Jones <davej@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Julius Werner <jwerner@chromium.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        James Morris <jmorris@namei.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sameer Nanda <snanda@chromium.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        Eric Dumazet <edumazet@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tend to agree with Dave that it's not in the user's best interest to
have a full-on BUG() here, and that we can get our reports just as
well by fishing them from the log through abrt or something similar. I
will just submit my alternative patch too and let you decide which one
you prefer.

This version shuts down the socket, so the broken receive queue will
not be used again and eventually freed. Other sockets and the system
as a whole will stay usable and probably still work if the bug is a
very rare coincidence. Of course, the driver will still be buggy, but
the same would stay true after a reboot (which is what most people do
after a panic). The userland caller gets an unexpected error code,
which is not the same as receiving a proper FIN and is the only thing
we can do to communicate this.
