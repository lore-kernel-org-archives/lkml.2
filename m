Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2KFACR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 19:02:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499Ab2KFACQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 19:02:16 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <s5hhap49den.wl%tiwai@suse.de>
References: <s5hhap49den.wl%tiwai@suse.de> <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <s5hobjia6vj.wl%tiwai@suse.de> <20121031173728.GA18615@srcf.ucam.org> <s5h390utqv3.wl%tiwai@suse.de> <1351743715.21227.95.camel@linux-s257.site> <20121101131849.752df6fd@pyramind.ukuu.org.uk> <s5hip9k9dng.wl%tiwai@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: dhowells@redhat.com, Matthew Garrett <mjg59@srcf.ucam.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, joeyli <jlee@suse.com>,
        Jiri Kosina <jkosina@suse.cz>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH RFC 0/4] Add firmware signature file check
Date: Tue, 06 Nov 2012 00:01:52 +0000
Message-ID: <5839.1352160112@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> this is a patch series to add the support for firmware signature
> check.  At this time, the kernel checks extra signature file (*.sig)
> for each firmware, instead of embedded signature.
> It's just a quick hack using the existing module signing mechanism,
> thus provided only as a proof of concept for now.

There is another way to do this.  If you look at the patches I proposed to
wrap keys in PE binaries, you'll find that that can handle PKCS#7 format
messages as that's what's in the sort of signed PE binary we're dealing with.

You could use this to put the firmware inside a signed-data PKCS#7 message.

David
