Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418Ab2EIRNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:13:52 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37869 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758456Ab2EIRNu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:13:50 -0400
MIME-Version: 1.0
In-Reply-To: <20120509163732.GN22082@ZenIV.linux.org.uk>
References: <1336577114.3638.23.camel@lappy> <20120509161203.GK22082@ZenIV.linux.org.uk>
 <CA+1xoqdEFOBPSng99jFcgj9Un9ZguXqKhXYdDCeKv3k5nLrC6Q@mail.gmail.com>
 <20120509162854.GM22082@ZenIV.linux.org.uk> <20120509163732.GN22082@ZenIV.linux.org.uk>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 9 May 2012 19:13:29 +0200
Message-ID: <CA+1xoqf=fDqJq1ks=fo9B27nGrAEVGArYSddmX49Otxw+jpKJw@mail.gmail.com>
Subject: Re: vfs: INFO: possible circular locking dependency detected
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 6:37 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> If that's _all_ that happened, I'm not particulary
> concerned; it's not pretty, but saying "thou shalt not grab ->cred_guard_mutex
> anywhere in ->read() on anything that has exec bits or might get one" is
> not too terrible.  If that's something else, though, we might have a real
> problem...

That's probably the case. The proc file got chmodded and exec'ed.

Can we do something to eliminate this false positive though? I can't
think of anything nice...

btw,
I've never seen this issue before, even though I run same tests for a
while now. What could have triggered it now?
