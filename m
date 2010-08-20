Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab0HTJJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 05:09:51 -0400
Received: from mx6.sophos.com ([213.31.172.36]:37126 "EHLO mx6.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab0HTJJt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 05:09:49 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: Re: [GIT PULL] notification tree: directory events
Date: Fri, 20 Aug 2010 10:09:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Andreas Gruenbacher <agruen@suse.de>,
        Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michael Kerrisk <michael.kerrisk@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008200141.10068.agruen@suse.de> <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
In-Reply-To: <1282275497.21419.2073.camel@acb20005.ipt.aol.com>
MIME-Version: 1.0
Message-ID: <201008201009.42066.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/08/2010 10:09:42,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 20/08/2010 10:09:43,
	Serialize complete at 20/08/2010 10:09:43
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 Aug 2010 04:38:17 Eric Paris wrote:
> On Fri, 2010-08-20 at 01:41 +0200, Andreas Gruenbacher wrote:
> >     (2) Construct a file descriptor that refers to the file that could not
> >     be
> >
> >         dentry_open()ed, but which cannot be used for any I/O, and pass
the
> >         error condition in a separate field.  The kernel has all the
> >         information needed for doing that, and it shouldn't be hard to
> >         implement.
> >
> >         That way, the listener always has a file descriptor to poke around
> >         with.
> >
> > Failing to do (2) right now, I think it still makes sense to separate the
> > file descriptor from the error code in struct fanotify_event_metadata;
> > this would enable us to do (2) later if we decide to.
>
> In reference to (2), I don't even understand what an fd is that can't be
> used for anything.  I'll let Al or Christoph respond if they feel like
> it, but it sounds crazy to me.  You want to just magic up some struct
> file and attach a struct path to it even though dentry_open() failed?
> So you can do what with it?

I think Andreas would like to get a path even if open failed so it could be
for that use? If creating such file object will be impossible or too hacky,
but the general idea accepted, it may be better just to attach the path to the
event.

Tvrtko

Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
