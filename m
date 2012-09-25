Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab2IYBqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:46:51 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53688 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754Ab2IYBqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:46:49 -0400
X-Sasl-enc: RZFVoTn6P1lUVr7Y1d64bqWz17ZQcloH7DZ+qTw3ejrX 1348537607
Message-ID: <1348537604.2307.8.camel@perseus.themaw.net>
Subject: Re: [PATCH 0/2] struct pid-ify autofs4
From: Ian Kent <raven@themaw.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com
Date: Tue, 25 Sep 2012 09:46:44 +0800
In-Reply-To: <87d31bczo7.fsf@tucsk.pomaz.szeredi.hu>
References: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
	 <87haqrwfbj.fsf@tucsk.pomaz.szeredi.hu>
	 <1348447130.2318.1.camel@perseus.themaw.net>
	 <87d31bczo7.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 15:34 +0200, Miklos Szeredi wrote:
> Ian Kent <raven@themaw.net> writes:
> 
> > On Fri, 2012-09-21 at 17:44 +0200, Miklos Szeredi wrote:
> >> Miklos Szeredi <miklos@szeredi.hu> writes:
> >> 
> >> > These two patches change autofs4 to store struct pid pointers instead of pid_t
> >> > values.
> >> >
> >> > Fixed various issues with the previous post.  Not tested, handle with
> >> > care!
> >> 
> >> Customer gave positive test results.
> >
> > For what exactly, there's no problem description in these patches?
> 
> From what I understand (and I'm not an expert by any means) is that
> autofs doesn't work if containers are used.  The first patch fixes this.

Yeah, the problem with that is that "autofs doesn't work if containers
are used" is ill defined since there are use cases where it does, I
believe. At the very least, ill defined in my view of things.

But I can't even sensibly discuss it because of the lack of specified
use cases and requirements for each. So, there's a chance this will
break another case that does work.

All I can do is ask annoying questions each time time I see related
patches.

> 
> Both the patches replace pid_t with a refcounted struct pid object,
> which has better lifetime properties: you don't know whether a pid_t is
> valid, because pid numbers are reused, while pid objects remain valid
> until there are no more references to them.

Yep, at least I got that.

> 
> Thanks,
> Miklos


