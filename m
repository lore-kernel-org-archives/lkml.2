Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448Ab2CMVeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:34:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51871 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751853Ab2CMVeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:34:24 -0400
X-Sasl-enc: 3aDuR8vQCMlm3HoLRMHQ0GXN6wMB1f/tL/uiIneJqmpx 1331674463
Message-ID: <1331674435.8346.29.camel@lenny>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
From: Colin Walters <walters@verbum.org>
To: Dave Jones <davej@redhat.com>
Cc: viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 13 Mar 2012 17:33:55 -0400
In-Reply-To: <20120313182220.GA11500@redhat.com>
References: <20120313182220.GA11500@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-13 at 14:22 -0400, Dave Jones wrote:
> This size is user controllable, and so it's trivial for someone to trigger a
> stream of order:4 page allocation errors.

I spent some time today struggling with an order:4 allocation failure
(my application uses CLONE_NEWNET to make an empty network stack for
software builds, and apparently one of the netfilter caches requires
this).

But is that the general principle, that we just add GFP_NOWARN if the
allocation size is trivially user controllable?  I guess examples like
fs/pipe.c:pipe_set_size() agree with you, but it feels kind of like
it's papering over the problem...



