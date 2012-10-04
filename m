Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965283Ab2JDOgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 10:36:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40194 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965038Ab2JDOgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 10:36:37 -0400
Date: Thu, 4 Oct 2012 16:36:20 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kay Sievers <kay@vrfy.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
In-Reply-To: <CA+55aFwz_7sksJRnFHZQFHD001ihF7ejkk5+-6Punc2dFtoqVQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1210041628400.9942@pobox.suse.cz>
References: <1340285798-8322-1-git-send-email-mchehab@redhat.com> <4FE37194.30407@redhat.com> <4FE8B8BC.3020702@iki.fi> <4FE8C4C4.1050901@redhat.com> <4FE8CED5.104@redhat.com> <20120625223306.GA2764@kroah.com> <4FE9169D.5020300@redhat.com>
 <20121002100319.59146693@redhat.com> <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com> <20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com> <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <alpine.LRH.2.00.1210030159440.31999@twin.jikos.cz> <CA+55aFwz_7sksJRnFHZQFHD001ihF7ejkk5+-6Punc2dFtoqVQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012, Linus Torvalds wrote:

> Now, at the same time, I do agree that network devices should generally 
> try to delay it until ifup time

Slightly tangential to the ongoing discussion, but still ... I think that 
even "all network drivers should delay firmware loading to ifup time" 
might be too general.

I would expect that there are network cards which require firmware to be 
present for PHY to work, right? On such cards, if you want to have link 
detection even on interfaces that are down (so that things like ifplugd 
can detect the link presence and configure the interface), ifup is too 
late.

I admit I haven't checked whether there actually are such cards out there, 
but it doesn't seem to be completely unrealistic to me.

-- 
Jiri Kosina
SUSE Labs
