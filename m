Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2LRV5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:57:07 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41632 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2LRV5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:57:03 -0500
Date: Tue, 18 Dec 2012 22:02:23 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] firmware: make sure paths remain relative
Message-ID: <20121218220223.5ae69bf0@pyramind.ukuu.org.uk>
In-Reply-To: <20121218210449.GA3329@www.outflux.net>
References: <20121218210449.GA3329@www.outflux.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012 13:04:49 -0800
Kees Cook <keescook@chromium.org> wrote:

> Some devices have configurable firmware locations. If these configuration
> mechanisms are exposed to unprivileged userspace, it may be possible to
> load firmware from an unexpected location. To minimize the risk of this,
> make sure the string "../" does not appear in the firmware name. This
> means that neither the users of request_firmware, nor the uevent handler
> have to do this filtering themselves.

Have you verified no existing distribution ever does this ?


> +	if (strstr(name, "../")) {

and this is obviously buggy and hasn't been tested

Hint foo/bar../baz

You need to check for ^../ /../ and /..$

Alan
