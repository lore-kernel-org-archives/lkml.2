Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1JOJ0T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 05:26:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40226 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751516Ab1JOJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 05:26:18 -0400
Date: Sat, 15 Oct 2011 10:25:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Godmar Back <godmar@gmail.com>, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>
Subject: Re: Q.: Why does tty_ioctl.c: set_termios return EINTR instead of
 ERESTARTSYS?
Message-ID: <20111015102559.3e85b32d@lxorguk.ukuu.org.uk>
In-Reply-To: <4E994A65.7000509@suse.cz>
References: <CAB4+JYLiF4wr+U5s_m15baC=Ktf8NnAYFKfcyhM3AxG9PZ4YPA@mail.gmail.com>
	<CAB4+JYJYVFouMYZMX4bGVA+vPm1rD3KY3GvwVjKBZS7bwf6-zQ@mail.gmail.com>
	<CAB4+JYLjjdo_nmwPqWTmd9YFk=4x4AVcprr-b7LoEc9JDqGthQ@mail.gmail.com>
	<4E994A65.7000509@suse.cz>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Is there a particular reason why it cannot be made restartable?
> 
> EINTR is used when there is no way to rollback already performed
> actions. In this case, a flush could be performed. (This holds only for
> TCSETSF, TCSETSF2 and similar.) So I think this is the reason we cannot
> return ERESTARTSYS.
> 
> However I CCed tty fellows, they may have a different opinion.

I don't actually know. I think Linus or Ted T'so were still doing the tty
code that long back. Ted also did some compliance testing on it way back
when (1995 or so ?)
