Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab0FWIIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 04:08:21 -0400
Received: from lo.gmane.org ([80.91.229.12]:43685 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab0FWIIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 04:08:19 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: SO_REUSEPORT
Date: Wed, 23 Jun 2010 08:54:08 +0100
Message-ID: <06r8f7-jsn.ln1@chipmunk.wormnet.eu>
References: <AANLkTimxGK93hnV9-jGZAeeJ_JnrWCTaq-dkDvfUW6St@mail.gmail.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.3-20080506 ("Dalintober") (UNIX) (Linux/2.6.26-2-sparc64-smp (sparc64))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Tim Prepscius <timprepscius@gmail.com> wrote:
> 
> Is SO_REUSEPORT available 2.6.ish - (or any version)?
> I've been searching for a conclusive answer to this question and can't
> find it.
>
That will be a no then:
----
alex@berk:~$ grep SO_REUSEPORT -r /usr/src/linux-2.6-stable/include/
/usr/src/linux-2.6-stable/include/asm-generic/socket.h:/* To add :#define SO_REUSEPORT 15 */
----

> (yes I know of SO_REUSEADDR, and I know the difference between this
> and *PORT, and yes I know that I *definitely* need SO_REUSEPORT, no,
> I'm unconcerned this may/may not be part of a "standard," yes I know
> it is implemented differently on different systems, yes I know there
> may be security problems, but no, I don't care about this.)
> 
This really sounds like the sort of thing (for TCP/SCTP) where the 
'master' process would maintain the listening socket and upon accept() 
you would fork() or pass the file descriptor off to a thread.  This 
would make SO_REUSEPORT un-necessary and also your code would be 
portable.

If you are doing things with UDP (or another datagram-esque stream) then 
your master listener could pass off the incoming packets to 
threads/processes trivially.

Of course this depends on what you are doing, but my opinion is that the 
functionality has been unneeded so far by people in the kernel, so *I* 
must be doing something wrong ;)

Cheers

-- 
Alexander Clouter
.sigmonster says: "Every man has his price.  Mine is $3.95."

