Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab2JYAct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 20:32:49 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50845 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932178Ab2JYAcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 20:32:46 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2012 20:32:46 EDT
X-Sasl-enc: mx5Wu2YsHuiDVMMpOkgCWiAAcnZZR2OaWSR6PFDeIsGO 1351124731
Message-ID: <1351124728.3116.8.camel@perseus.themaw.net>
Subject: Re: [PATCH 0/2] struct pid-ify autofs4
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, autofs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sukadev@linux.vnet.ibm.com, serge.hallyn@canonical.com
Date: Thu, 25 Oct 2012 08:25:28 +0800
In-Reply-To: <87625z531j.fsf@tucsk.pomaz.szeredi.hu>
References: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
	 <87haqrwfbj.fsf@tucsk.pomaz.szeredi.hu>
	 <1348447130.2318.1.camel@perseus.themaw.net>
	 <87d31bczo7.fsf@tucsk.pomaz.szeredi.hu>
	 <1348537604.2307.8.camel@perseus.themaw.net> <87mx0estch.fsf@xmission.com>
	 <1349926483.2371.35.camel@perseus.themaw.net>
	 <87625z531j.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-24 at 16:59 +0200, Miklos Szeredi wrote:
> > Ian Kent <raven@themaw.net> writes:
> > 
> > > Yeah, the problem with that is that "autofs doesn't work if containers
> > > are used" is ill defined since there are use cases where it does, I
> > > believe. At the very least, ill defined in my view of things.
> 
> Customer says:
> 
>  "There is no interaction between host and the conatainer.  The host use
>   only his own automount and each containers used automount in their
>   container."

That sounds like a sensible requirement to me.

> 
> I think it's a pretty clearly defined use case.  And one which automount
> could easily support since the only requirement is that all namespaces
> are treated equally.

Yep. A problem might be dealing with mounts cloned from the parent
namespace at container creation. Ideally they wouldn't be duplicated so
they wouldn't need to be cleaned up (perhaps that's justified given the
requirement above).

Another thought is, what would happen on just cloning a namespace, not
necessarily as a container (is that even a sensible question)? The user
may actually want the mounts in this case, and can we even tell the
difference at namespace creation?

> 
> But I agree that adding safeguards against cases which don't have such
> easily defined semantics (such as triggers from several different
> namespaces).

Look forward to it.

> 
> I'll post updated patches.
> 
> Thanks,
> Miklos
> 


