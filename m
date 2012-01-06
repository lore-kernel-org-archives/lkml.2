Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab2AFO1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 09:27:37 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35810 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab2AFO1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 09:27:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAHFgRy8GUhyBZonZ_3c2=COxnCJ9DhX6EiaKe3JpMWaSpYJWWw@mail.gmail.com>
References: <CAHFgRy8GUhyBZonZ_3c2=COxnCJ9DhX6EiaKe3JpMWaSpYJWWw@mail.gmail.com>
Date: Fri, 6 Jan 2012 09:27:35 -0500
Message-ID: <CA+5PVA61GC=JjiB3BcujC0ZKbgFjgbm5QzLLxES2gLkBMCA2eQ@mail.gmail.com>
Subject: Re: panic - init: io.c:1312: Unhandled error from nih_io_destroy: Bad
 file descriptor
From: Josh Boyer <jwboyer@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 6:10 PM, Miles Lane <miles.lane@gmail.com> wrote:
> Suddenly, all my kernels are failing to boot.  These include ones from
> Ubuntu 12.04 and my Linus' GIT kernels.  Any suggestions for what
> might be broken?  Is it possible for me to fix this?
>
> init: log.c:291: Assertion failed in log_io_error_handler: err->number == EIR
> init: Caught abort, core dumped
> init: io.c:1312: Unhandled error from nih_io_destroy: Bad file descriptor
> init: Caught abort. core dumped

Those are error messages from Upstart, not the kernel.  It seems to
have some kind of internal issue and exits.  Since it's PID 1, it
panics the kernel because init can't exit.

You might want to see if you updated upstart or libnih recently and
downgrade if so.

josh
