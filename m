Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab2BWTmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:42:13 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64859 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2BWTmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:42:11 -0500
MIME-Version: 1.0
In-Reply-To: <20120223193620.GA16477@kroah.com>
References: <alpine.LFD.2.02.1202221252060.20522@i5.linux-foundation.org>
 <4F456D8F.1080801@zytor.com> <CA+55aFw4P1qUye5YOJKSQHX+TfxbEDWMF7LPogj128b6gv2Nqg@mail.gmail.com>
 <CA+55aFziJ=Lw0KxxThwfqRPR+K0OWDorKAfkgKMGPXv5O404JA@mail.gmail.com>
 <4F4584EB.9060605@zytor.com> <CA+55aFxC6JwWsNcmkQ+DROXtWCzaq52DuX5aMJZfXMLoNCbsWg@mail.gmail.com>
 <20120223003706.GA3246@kroah.com> <6e9d38ffcb1a66f62a335450d4722809@buro.asia>
 <CA+55aFxTieMqacU9LN8Xmtb3Os8zkub1P+SKpqFtEBQ11STy7g@mail.gmail.com>
 <e709c3b5c5b2aa6e6a9d049f3af857e3@buro.asia> <20120223193620.GA16477@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 11:41:50 -0800
X-Google-Sender-Auth: DWFzDIXjT_LOw15MR6KR9QUQYpM
Message-ID: <CA+55aFwZqBdvB4HrW_mSzksimrWyRDhphkLbKxE9azmcb305Ow@mail.gmail.com>
Subject: Re: [PATCH 0/5] i387: stable kernel backport
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: raphael@buro.asia, "H. Peter Anvin" <hpa@zytor.com>,
        stable@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 11:36 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>

The insane safe_address games go away in the cleanup patch, so it
really shouldn't be much of an issue.

In the end, save_address should just be

  #define safe_address (tsk->thread.has_fpu)

(and in fact the whole #define got removed entirely in mainline in
commit 80ab6f1e8c98, which might be fodder for -stable too)

                 Linus
