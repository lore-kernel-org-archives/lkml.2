Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2KTVIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 16:08:00 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33193 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab2KTVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 16:07:59 -0500
Date: Tue, 20 Nov 2012 21:13:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ellyjones@chromium.org, Kay Sievers <kay@vrfy.org>,
        Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v2] devtmpfs: mount with noexec and nosuid
Message-ID: <20121120211312.57f1b63d@pyramind.ukuu.org.uk>
In-Reply-To: <20121120204238.GA19554@www.outflux.net>
References: <20121120204238.GA19554@www.outflux.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Nov 2012 12:42:38 -0800
Kees Cook <keescook@chromium.org> wrote:

> Since devtmpfs is writable, make the default noexec,nosuid as well. This
> protects from the case of a privileged process having an arbitrary file
> write flaw and an argumentless arbitrary execution (i.e. it would lack
> the ability to run "mount -o remount,exec,suid /dev").

Ok this looks crap on two levels.

1. Why not just have your userspace mount -o remount the file system this
way already in early boot. (and if you trojanned boot that early then any
supposed security gain is already lost)

2. If you want to do this right then you need to work out what you are
trying to prevent. Your devtmpfs can force file permissions on the
underlying device nodes by having its own operation handling for chmod.

At that point you can force permissions on anything that you want to
avoid floating around that filesystem with other rights, while not
touching it on device or directory nodes where the meaning is different.

In its current form however it appears to be a kernel implementation of
"mount is too hard".

Alan
