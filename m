Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2KXVNB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 16:13:01 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54926 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab2KXVM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 16:12:59 -0500
MIME-Version: 1.0
X-Originating-IP: [94.21.63.42]
In-Reply-To: <878v9rmcgc.fsf@xmission.com>
References: <87obipehbt.fsf@tucsk.pomaz.szeredi.hu>
	<1353642304.2309.25.camel@perseus.themaw.net>
	<1353672540.6699.18.camel@perseus.themaw.net>
	<874nkgwfw0.fsf@tucsk.pomaz.szeredi.hu>
	<1353723813.2348.48.camel@perseus.themaw.net>
	<1353724641.2348.56.camel@perseus.themaw.net>
	<878v9rmcgc.fsf@xmission.com>
Date: Sat, 24 Nov 2012 22:12:58 +0100
Message-ID: <CAJfpegvQGhzDvQt=OBf=GVQF2gDynTp6F+zO-dn5skFLtukFCQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] autofs4: allow autofs to work outside the initial PID namespace
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ian Kent <raven@themaw.net>, autofs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, serge.hallyn@canonical.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 1:07 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Ian Kent <raven@themaw.net> writes:
>
>> On Sat, 2012-11-24 at 10:23 +0800, Ian Kent wrote:
>>> On Fri, 2012-11-23 at 15:30 +0100, Miklos Szeredi wrote:

>>> AFAICS autofs mounts mounted with MS_PRIVATE in the initial namespace do
>>> propagate to the clone when it's created so I'm assuming subsequent
>>> mounts would also. If these mounts are busy in some way they can't be
>>> umounted in the clone unless "/" is marked private before attempting the
>>> umount.
>>
>> This may sound stupid but if there something like, say, MS_NOPROPAGATE
>> then the problem I see would pretty much just go away. No more need to
>> umount existing mounts and container instances would be isolated. But, I
>> guess, I'm not considering the possibility of cloned of processes as
>> well .... if that makes sense, ;)
>
> Something is very weird is going on.  MS_PRIVATE should be the
> MS_NOPROPOGATE you are looking for.  There is also MS_UNBINDABLE.
> which is a stronger form of MS_PRIVATE and probably worth play with.
>

MS_UNBINDABLE says:  skip this mount when copying a mount tree, such
as when the mount namespace is cloned.

If you set MS_UNBINDABLE on autofs mounts then they will simply not
appear in a cloned namespace.  Which sounds like a good idea,  no?

Thanks,
Miklos
