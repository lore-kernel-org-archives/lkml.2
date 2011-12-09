Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab1LIPGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 10:06:33 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53877 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752292Ab1LIPGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 10:06:31 -0500
X-Sasl-enc: GKaDPB2hUJSnhCuSmzfF8pBfpGMSIEBn0mHhu/1oc6po 1323443191
Subject: Re: chroot(2) and bind mounts as non-root
From: Colin Walters <walters@verbum.org>
To: John Stoffel <john@stoffel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 09 Dec 2011 10:06:10 -0500
In-Reply-To: <20194.8535.854625.466329@quad.stoffel.home>
References: <1323280461.10724.13.camel@lenny>
	 <20191.49202.793643.397028@quad.stoffel.home>
	 <1323360655.10724.35.camel@lenny>
	 <20192.65168.140290.462594@quad.stoffel.home>
	 <1323368800.10724.73.camel@lenny>
	 <20194.8535.854625.466329@quad.stoffel.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1323443171.6008.11.camel@lenny>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-09 at 09:55 -0500, John Stoffel wrote:

> I can see that, but maybe you can still fix this in userspace using
> the schroot tool others have mentioned.  

No, because it requires root to edit /etc/schroot/schroot.conf.  I've
already said this.  What is not being understood?

Again, the design constraint I have is that you should be able to get a
plain regular Unix account on say some classical timesharing server (in
the cloud if you like, or your university's RHEL instance), and do the
build.

This is also advantageous even in the "building on personal laptop case"
in that there is *no* instance of a user process being in direct or
indirect control over processes started as root - much less chance one
of those random postinst scripts that run as root not noticing they're
in a chroot and screwing your system.

If you allow the a user to upload .debs to the URL in schroot.conf, all
you have created in the end is a very elaborate chmod u+s /bin/sh for
them.

Does that make sense?  Stop telling me about schroot, I knew about it
even before I posted here, and I've already replied about it.



