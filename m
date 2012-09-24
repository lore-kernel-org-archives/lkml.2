Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab2IXNev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:34:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35380 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674Ab2IXNet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:34:49 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Ian Kent <raven@themaw.net>
Cc: autofs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sukadev@linux.vnet.ibm.com,
        serge.hallyn@canonical.com, ebiederm@xmission.com
Subject: Re: [PATCH 0/2] struct pid-ify autofs4
References: <1348068576-21363-1-git-send-email-miklos@szeredi.hu>
	<87haqrwfbj.fsf@tucsk.pomaz.szeredi.hu>
	<1348447130.2318.1.camel@perseus.themaw.net>
Date: Mon, 24 Sep 2012 15:34:32 +0200
In-Reply-To: <1348447130.2318.1.camel@perseus.themaw.net> (Ian Kent's message
	of "Mon, 24 Sep 2012 08:38:50 +0800")
Message-ID: <87d31bczo7.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> On Fri, 2012-09-21 at 17:44 +0200, Miklos Szeredi wrote:
>> Miklos Szeredi <miklos@szeredi.hu> writes:
>> 
>> > These two patches change autofs4 to store struct pid pointers instead of pid_t
>> > values.
>> >
>> > Fixed various issues with the previous post.  Not tested, handle with
>> > care!
>> 
>> Customer gave positive test results.
>
> For what exactly, there's no problem description in these patches?

>From what I understand (and I'm not an expert by any means) is that
autofs doesn't work if containers are used.  The first patch fixes this.

Both the patches replace pid_t with a refcounted struct pid object,
which has better lifetime properties: you don't know whether a pid_t is
valid, because pid numbers are reused, while pid objects remain valid
until there are no more references to them.

Thanks,
Miklos
