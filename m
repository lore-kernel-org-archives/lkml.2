Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314Ab2DNBO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 21:14:59 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:59333 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab2DNBO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 21:14:57 -0400
X-Greylist: delayed 995 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Apr 2012 21:14:56 EDT
Message-ID: <1334365079.25130.21.camel@lade.trondhjem.org>
Subject: Re: [PATCH RFC] vfs: make fstatat retry on ESTALE errors from
 getattr call
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Peter Staubach <pstaubach@exagrid.com>
Cc: Steve Dickson <SteveD@redhat.com>, Jeff Layton <jlayton@redhat.com>,
        Malahal Naineni <malahal@us.ibm.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "miklos@szeredi.hu" <miklos@szeredi.hu>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "hch@infradead.org" <hch@infradead.org>,
        "michael.brantley@deshaw.com" <michael.brantley@deshaw.com>
Date: Fri, 13 Apr 2012 20:57:59 -0400
In-Reply-To: <2F609A9B-B44B-4CEA-BF35-D6BEDA729363@exagrid.com>
References: <1334316311-22331-1-git-send-email-jlayton@redhat.com>
	 <20120413150518.GA1987@us.ibm.com>
	 <20120413114236.0e557e01@tlielax.poochiereds.net>
	 <4F884F32.7010402@RedHat.com>
	 <2F609A9B-B44B-4CEA-BF35-D6BEDA729363@exagrid.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-UiO-Ratelimit-Test: rcpts/h 11 msgs/h 1 sum rcpts/h 11 sum msgs/h 1 total rcpts 1672 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 587F89FF30D2C5D529BB88307270F912C944BD67
X-UiO-SPAM-Test: remote_host: 71.238.149.92 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 12 max/h 2 blacklist 0 greylist 0 ratelimit 0
X-UiOonly: 029F2A167D2E47C4BC6DB5B74696D965A5F760BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-04-13 at 13:34 -0400, Peter Staubach wrote:
> I still think that returning ESTALE to the application is just exposing a short coming in the implementation.  From a path based system like stat(), the application should see either ENOENT or some sort valid return.
> 
> I also look at the looping from the other side.  While possible, of course, I'd like to see someone construct a situation where it really happens.  By this, I don't mean a thought experiment, but a real running situation.
> 
> We already have evidence, in the form of the Solaris NFS client, that infinite looping does not happen in nature.

Could we turn that statistic around? Has the Solaris client ever seen a
loop of more than, say, 5 or 6 retries?

I'm just trying to limit the scope of the problem...

Cheers
  Trond

