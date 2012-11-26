Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab2KZC3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 21:29:35 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33164 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686Ab2KZC3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 21:29:33 -0500
X-Sasl-enc: NaR1fkgrDx9rCVfLaqDJvQpw1JU46JBVWck0IUGd1C2l 1353896971
Message-ID: <1353896968.2323.7.camel@perseus.themaw.net>
Subject: Re: [PATCH 1/2] autofs4: allow autofs to work outside the initial
 PID namespace
From: Ian Kent <raven@themaw.net>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, autofs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, serge.hallyn@canonical.com
Date: Mon, 26 Nov 2012 10:29:28 +0800
In-Reply-To: <1353885956.2323.4.camel@perseus.themaw.net>
References: <87obipehbt.fsf@tucsk.pomaz.szeredi.hu>
	 <1353642304.2309.25.camel@perseus.themaw.net>
	 <1353672540.6699.18.camel@perseus.themaw.net>
	 <874nkgwfw0.fsf@tucsk.pomaz.szeredi.hu>
	 <1353723813.2348.48.camel@perseus.themaw.net>
	 <1353724641.2348.56.camel@perseus.themaw.net> <878v9rmcgc.fsf@xmission.com>
	 <CAJfpegvQGhzDvQt=OBf=GVQF2gDynTp6F+zO-dn5skFLtukFCQ@mail.gmail.com>
	 <87lidqfx3u.fsf@xmission.com> <1353885956.2323.4.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-26 at 07:25 +0800, Ian Kent wrote:
> On Sat, 2012-11-24 at 14:35 -0800, Eric W. Biederman wrote:
> > Miklos Szeredi <miklos@szeredi.hu> writes:
> > 
> > > On Sat, Nov 24, 2012 at 1:07 PM, Eric W. Biederman
> > > <ebiederm@xmission.com> wrote:
> > >> Ian Kent <raven@themaw.net> writes:
> > >>
> > >>> On Sat, 2012-11-24 at 10:23 +0800, Ian Kent wrote:
> > >>>> On Fri, 2012-11-23 at 15:30 +0100, Miklos Szeredi wrote:
> > >
> > >>>> AFAICS autofs mounts mounted with MS_PRIVATE in the initial namespace do
> > >>>> propagate to the clone when it's created so I'm assuming subsequent
> > >>>> mounts would also. If these mounts are busy in some way they can't be
> > >>>> umounted in the clone unless "/" is marked private before attempting the
> > >>>> umount.
> > 
> > Subsequent mounts after the clone do not have a mechanism to propogate
> > with MS_PRIVATE.  As creating a new mount namespaces is essentially
> > an instance of mount --bind.  Those semantics are a little unintuitive
> > I have to admit.
> > 
> > >>> This may sound stupid but if there something like, say, MS_NOPROPAGATE
> > >>> then the problem I see would pretty much just go away. No more need to
> > >>> umount existing mounts and container instances would be isolated. But, I
> > >>> guess, I'm not considering the possibility of cloned of processes as
> > >>> well .... if that makes sense, ;)
> > >>
> > >> Something is very weird is going on.  MS_PRIVATE should be the
> > >> MS_NOPROPOGATE you are looking for.  There is also MS_UNBINDABLE.
> > >> which is a stronger form of MS_PRIVATE and probably worth play with.
> > >>
> > >
> > > MS_UNBINDABLE says:  skip this mount when copying a mount tree, such
> > > as when the mount namespace is cloned.
> > >
> > > If you set MS_UNBINDABLE on autofs mounts then they will simply not
> > > appear in a cloned namespace.  Which sounds like a good idea,  no?
> > 
> > Good point.  If the desire is for a mount to be managed by autofs
> > setting MS_UNBINDABLE seems required.
> 
> Arrgh, I know that's something I should have looked into long ago.
> The fact is that autofs mounts are directly related to a specific path
> defined by automount maps that are associated with the daemon so bind
> mounting them elsewhere makes no sense.

Except, AFAICS, they do appear in the clone.

> 
> Is it necessary (or sensible) to use MS_PRIVATE with MS_UNBINDABLE?

and specifying MS_PRIVATE as well gives an EINVAL return.

> 
> > 
> > Eric
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe autofs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


