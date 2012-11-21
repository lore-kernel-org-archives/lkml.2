Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2KUA0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 19:26:48 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33438 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2KUA0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 19:26:48 -0500
Date: Wed, 21 Nov 2012 00:32:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Kay Sievers <kay@vrfy.org>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v2] devtmpfs: mount with noexec and nosuid
Message-ID: <20121121003201.24181fdf@pyramind.ukuu.org.uk>
In-Reply-To: <CAGXu5jK5VWU8qxOAsrhSMrrdDaZVpLJWw0dQk3newvUK56rzVw@mail.gmail.com>
References: <20121120204238.GA19554@www.outflux.net>
	<CAPXgP126a0Wqw2NtkAAo6eqd1tvQyjLE0Kh=de3Cs2bd90K+8g@mail.gmail.com>
	<CAGXu5jK5VWU8qxOAsrhSMrrdDaZVpLJWw0dQk3newvUK56rzVw@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 16:18:33 -0800
Kees Cook <keescook@chromium.org> wrote:

> On Tue, Nov 20, 2012 at 4:13 PM, Kay Sievers <kay@vrfy.org> wrote:
> > On Tue, Nov 20, 2012 at 9:42 PM, Kees Cook <keescook@chromium.org> wrote:
> >> Since devtmpfs is writable, make the default noexec,nosuid as well. This
> >> protects from the case of a privileged process having an arbitrary file
> >> write flaw and an argumentless arbitrary execution (i.e. it would lack
> >> the ability to run "mount -o remount,exec,suid /dev").
> >
> > This only really applies to systems without an initramfs when the
> > kernel mounts /dev over the rootfs it has mounted; with an initramfs,
> > /dev is always mounted by user code.
> >
> > Just checking, that is the use case you are doing that for?
> 
> Correct. We're using this in Chrome OS, which does not use an initramfs.

But which has a perfectly good init process of its own, so it's just fine.

If you fix your init to do the work then you can deploy it to all your
Google partners and onto existing devices in an update even with old
kernels. Far better security practise.

Alan
