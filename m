Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab0HYGo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 02:44:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281Ab0HYGox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 02:44:53 -0400
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
From: Tomas Mraz <tmraz@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Miloslav Trma? <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org,
        Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
        Neil Horman <nhorman@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100825062000.GA1424@ucw.cz>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com>
	 <20100825062000.GA1424@ucw.cz>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Wed, 25 Aug 2010 08:44:39 +0200
Message-ID: <1282718679.2930.42.camel@vespa.frost.loc>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 08:20 +0200, Pavel Machek wrote: 
> Hi!
> 
> > Motivations for the extensions: governments are asking for more security
> > features in the operating systems they procure, which make user-space
> > implementations impractical.  A few examples:
> > 
> > * Advanced crypto module for OSPP for Common Criteria requires OS services
> >   implementing several low-level crypto algorithms (e.g. AES, RSA).  This
> >   requires the separation of crypto services from the consumer of those
> >   services. (The threat model is that apps tend to have more vulnerabilities
> >   than libraries and compromise of the app will lead to the ability to access
> >   key material.) An user-space library is not separated, options are a) root
> >   running daemon that does crypto, but this would be slow due to context
> >   switches, scheduler mismatching and all the IPC overhead and b) use crypto
> >   that is in the kernel.
> 
> Hmm, root daemon seems like a way to go. You already do the switch
> into the kernel... and "IPC is slow" is not good enough reason to put
> everything in kernel. Plus, you should be able to get better usage of
> multicore with daemon.

Actually not, and the arguments why multicore would not be really used
better anyway were stated here as well. If an application needs some
cryptography function in most of the cases it has to wait for the
operation to finish before it can proceed  further. To use asynchronous
crypto interfaces efficiently would require serious redesign and rewrite
of the existing applications which is nowhere near to be accomplished.
In case of applications where the benefits of asynchronous crypto would
be obvious and easily utilized it is quite easier just to split the
threads for crypto processing and the rest of the application directly
inside the application process.
-- 
Tomas Mraz
No matter how far down the wrong road you've gone, turn back.
                                              Turkish proverb

