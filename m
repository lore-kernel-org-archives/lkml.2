Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2HUJKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 05:10:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54818 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab2HUJKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 05:10:35 -0400
Date: Tue, 21 Aug 2012 10:15:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.sf.net,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH] fbcon: fix race condition between console lock and
 cursor timer
Message-ID: <20120821101505.61c0221a@pyramind.ukuu.org.uk>
In-Reply-To: <1345531207-24926-1-git-send-email-airlied@redhat.com>
References: <1345531207-24926-1-git-send-email-airlied@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So after much tracing with direct netconsole writes (printks
> under console_lock not so useful), I think I found the race.

Direct netconsole write would be a useful patch to have mainline I think
8)

> Hopefully this fixes the problem for anyone seeing vesafb->kms
> driver handoff.

Not really the proper fix but its clear and is probably the best thing to
go in initially with a cc: stable. Can you at least stick a large 

+ /* FIXME: we should sort out the unbind locking instead */

on the patch however.
