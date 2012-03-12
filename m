Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab2CLTI1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:08:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab2CLTI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:08:26 -0400
Date: Mon, 12 Mar 2012 20:08:18 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Kushal Das <kdas@redhat.com>
Subject: Re: Extending coredump note section to contain filenames
Message-ID: <20120312190818.GA25523@host2.jankratochvil.net>
References: <4F5A3A4D.1020008@redhat.com>
 <20120309172934.GA18173@host2.jankratochvil.net>
 <4F5DE6A4.2030303@redhat.com>
 <20120312165359.GA32400@host2.jankratochvil.net>
 <4F5E4757.705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E4757.705@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012 19:58:31 +0100, Denys Vlasenko wrote:
>      This is better, isn't it?
>      Wouldn't it be nice if gdb would retrieve binary's name by itself?

Yes, that yum should have been executed automatically, instead of just
suggested by that:
	Try: yum --disablerepo='*' --enablerepo='*-debuginfo' install /usr/lib/debug/.build-id/ec/1fd70dbee0db36eff9527254d9d2bbfd260f13

But this is a user interface issue, it was discussed with PackageKit people
etc. but it went nowhere.

Sorry but I cannot code the whole OS myself including all the Gnome UI
interfaces.


>      (BTW: nothing prevents it from checking build ids and refusing
>      to use it if they don't match.)

And if they do not match it will need to run the yum command above anyway.
So why to code two ways where the first one (by filename) works only sometimes
while the second way works always?  Isn't it easier to do it always just the
second way?


> >The build-id mapping server above always works and without races.
> 
> But it is not always available. Some people don't want to be connected
> to internet; other can't be connected.

That 'yum' command above will run in some conditions without any Internet
connectivity.  But in some cases it will have more bandwidth requirements than
a build-id server query.

This is about package management vs. network servers connectivity, this is
also partially distro dependent.


> Does it follow from the above that filenames are *never* useful?

They can be sometimes useful but they are superseded by build-ids; with
build-ids they can be safely ignored.


Regards,
Jan
