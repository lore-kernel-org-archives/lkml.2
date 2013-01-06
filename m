Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057Ab3AFUVJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 15:21:09 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:63080 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360Ab3AFUVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 15:21:07 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAKgNAkjF+9d3_UhzOM-1H+F9W6UAhWDnugS__XzFiL-b2a3gyQ@mail.gmail.com>
References: <CAKgNAkjF+9d3_UhzOM-1H+F9W6UAhWDnugS__XzFiL-b2a3gyQ@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Sun, 6 Jan 2013 21:20:47 +0100
Message-ID: <CAKgNAki7C+MRJzmQ6shEdyZZp5qVoYgv664ZFat7feYjUbwrMQ@mail.gmail.com>
Subject: Re: init_module.2 man page ERRORS text for signed modules
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Just after sending, I noticed an error in the text for those errors.
I've amended and am resending]

Hi David, Rusty,

Linux 3.7 added signed modules. As a consequence, init_module()
acquired some new possible error returns. I've put together the text
below to describe the new errors. Does the text look okay?

Thanks,

Michael

.TP
.BR EBADMSG " (since Linux 3.7)"
Module signature is misformatted.
.TP
.BR ENOKEY " (since Linux 3.7)"
.\" commit 48ba2462ace6072741fd8d0058207d630ce93bf1
.\" commit 1d0059f3a468825b5fc5405c636a2f6e02707ffa
.\" commit 106a4ee258d14818467829bf0e12aeae14c16cd7
Module signature is invalid or the kernel does not have a key for this module.
This error is returned only if the kernel was configured with
.BR CONFIG_MODULE_SIG_FORCE ;
if the kernel was not configured with this option,
then an invalid or usigned module simply taints the kernel.
