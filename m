Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab1KOUX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:23:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40858 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab1KOUX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:23:58 -0500
MIME-Version: 1.0
In-Reply-To: <CALmbKGV0g2nfNAghF5dGrt=TCyrms6RznOL8jSkg+gkgyfekLg@mail.gmail.com>
References: <CALmbKGV0g2nfNAghF5dGrt=TCyrms6RznOL8jSkg+gkgyfekLg@mail.gmail.com>
Date: Tue, 15 Nov 2011 21:23:57 +0100
Message-ID: <CAFLxGvynabpEcX2RwiLxatjOEzizj95jAVY6E4D9ymDpn8s9UA@mail.gmail.com>
Subject: Re: Finding a hidden bound TCP socket
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "G. D. Fuego" <gdfuego@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 8:21 PM, G. D. Fuego <gdfuego@gmail.com> wrote:
> Hello,
>
> I have a question about an odd linux networking behavior, that could
> potentially be a local networking DoS.  I'm curious if anyone is
> familiar with this behavior.
>
> Essentially I was assisting someone with tracking down a hidden tcp
> connection.  Attempts to bind to a particular port were failing,
> saying the socket was in use, even though netstat was not reporting
> any sort of connection.  They were initially suspecting a root kit,
> but after a bit of digging, I came across this page:
>
> http://dcid.me/2007/06/hidden-ports-on-linux/
>
> From the page:
>
> "Here is the idea. If you get this simple C program, it will attempt
> to bind every TCP port from 1025 to 1050, but it will not listen on
> them. After it is done, if you do a netstat (or fuser or lsof) nothing
> will be shown. However, if you try to use the port, you will get an
> error saying that it is already in use."
>
> I tested it out and confirmed that connections opened by their test
> program do in fact cause the port to be unavailable for use, and they
> are not reported in netstat, lsof, ss, or any other networking tools
> that I tried.  I'm unable to to find any references to the ports being
> in use anywhere I've looked within /proc.  Are you aware of another
> way to figure out which process may be bound to the port?  In our
> case, we figured out via trial and error which software was likely
> triggering this behavior.
>
> It seems to me that this could be a potentially interesting local
> networking DoS.  By binding to all ephemeral ports in this way, you'd
> prevent the local system from being able to establish any tcp
> connections, and it would be a pain to figure out which process was
> causing the problem.
>
> My lame attempts to exploit this failed due to a max file descriptor
> limit, but I'm told this could be doable by forking more processes for
> doing the binding.
>
> Is this behavior known/expected?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

CC'ing netdev

-- 
Thanks,
//richard
