Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2FLQv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:51:28 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:54444 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2FLQv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:51:27 -0400
Date: Tue, 12 Jun 2012 17:55:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org,
        jbottomley@parallels.com
Subject: Re: [PATCH] scsi: allow persistent reservations without
 CAP_SYS_RAWIO
Message-ID: <20120612175503.3462962f@pyramind.ukuu.org.uk>
In-Reply-To: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012 18:08:32 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Persistent reservations commands cannot be issued right now without
> giving CAP_SYS_RAWIO to the process who wishes to send them.  This
> is a bit heavy-handed, allow these two commands.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>         Ok for 3.5 as well?

NAK.

Persistent reservations are exactly the kind of command that should have
a security model attached to them.

Red Hat seems to be an ever growing source of "mummy its hard, lets
disable all the security" type fixes. Please stop it.

There is a sensible debate to be had about whether a lesser privilege
ought to be allowed. The real fix to this as with half of the other
crazy attempts to break all the security models that seem to keep spewing
forth is for someone who cares about it (that seems to me Red Hat) add
support for pushing a BPF filter onto a block device command queue. 

All the supporting code is there and used for other stuff, we can even
jit the things, not that it's a fast path here.

Alan
