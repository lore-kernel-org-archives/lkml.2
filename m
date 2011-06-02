Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655Ab1FBNLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:11:42 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51800 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751514Ab1FBNLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:11:40 -0400
Date: Thu, 2 Jun 2011 14:12:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <daniel.lezcano@free.fr>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>
Subject: Re: [PATCH] sysctl: add support for poll()
Message-ID: <20110602141234.4f5bffef@lxorguk.ukuu.org.uk>
In-Reply-To: <BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
References: <1306930476-1899-1-git-send-email-lucas.demarchi@profusion.mobi>
	<BANLkTin6CP-A+UsGXyu9wb7U34wEN7DKsw@mail.gmail.com>
	<m18vtkq57c.fsf@fess.ebiederm.org>
	<BANLkTimcPweT-HONEtVDn3mD2a6dUGDEYA@mail.gmail.com>
	<20110602134338.0c56160e@lxorguk.ukuu.org.uk>
	<BANLkTik72cU_R5k9NLnqN_FNkm-y5Fk0nQ@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Or to manage it properly.
> 
> What if the user decides do invoke sethostname syscall "by hand"?
> Hostname would change beneath any other process that is trying to
> manage it properly. What this patch does is to notify that process
> that something happened.

That is a stupid argument. Shall we extend it to its logical idiotic end
and ask

"What if the user decides to recompile their kernel without sysfs poll
support ?"

You have to be root to run sethostname, at which point you are
realistically at the command line, a superuser and you know what you are
doing (eg using sethostname for non IP network naming, or cluster id, or
other stuff).

> With this patch in, if anyone wants to manage a file under /proc/sys
> there's really a small amount of code to write. He only has to define
> the new poll struct for that file.

Sure - and there is an 8 byte cost per sysctl node (of which we have
rather a lot), and we really need to tackle sysfs not sysctl anyway.

I'm not averse to pollable sysfs/sysctl nodes at all although the memory
hit on sysfs is going to be tricky to manage and need clever code.

I just think the utsname is a completely misguided example and whoever is
trying to do it doesn't actually understand the limits of utsname.

Alan

