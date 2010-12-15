Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0LOUw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:52:56 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48691 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0LOUwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:52:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=poffEktrbNCDMUkT0chNfNQXzfPZ7E96eQwGdZOMBn/fJVxKjZ+5D6mBWJmMGfzEHi
         ZKk/rWSPykfIRzzlcB6usmfB2Iuf9bTDaxtJ1U704h2tnLlRan8o9/1gpKtnQC6qZ5Wj
         5aIo10dzyGvNwY4pEFS5D3rEryni1K3lu1/rE=
Subject: Re: [PATCH v2] fs: select: fix information leak to userspace
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Al Viro <viro@ZenIV.linux.org.uk>, P??draig Brady <P@draigBrady.com>,
        Am??rico Wang <xiyou.wangcong@gmail.com>, wharms@bfs.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>, kernel-janitors@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Jelinek <jakub@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1012152133010.29684@ask.diku.dk>
References: <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
	 <20101114092533.GB5323@albatros>
	 <20101114180643.593d19ac.akpm@linux-foundation.org>
	 <1289848341.2607.125.camel@edumazet-laptop> <20101123140111.GA3816@hack>
	 <4CEBD37E.5060107@bfs.de> <203E1F2A-2D04-4B7F-8D1B-9DC24522CB5E@dilger.ca>
	 <4CECECA2.6070301@draigBrady.com>
	 <20101124110535.GD5139@cr0.nay.redhat.com>
	 <4CECFB19.1090003@draigBrady.com>
	 <20101215094953.GG19804@ZenIV.linux.org.uk>
	 <0BAF9CFC-72BF-49A1-93D3-BF60B892389B@dilger.ca>
	 <Pine.LNX.4.64.1012152133010.29684@ask.diku.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 21:52:48 +0100
Message-ID: <1292446368.2603.13.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 décembre 2010 à 21:33 +0100, Julia Lawall a écrit :
> On Wed, 15 Dec 2010, Andreas Dilger wrote:
> 
> > On 2010-12-15, at 02:49, Al Viro wrote:
> > > Incorrect.  See 6.2.6.1 in C99; basically, padding bytes have unspecified
> > > contents.  Implementation is allowed to leave them in any state
> > > (including not bothering to copy them when doing struct assignments,
> > > etc.).  See Appendix J (portability issues) as well.
> > > 
> > > The bottom line: if you rely on that, you are relying on non-portable
> > > details of compiler behaviour.  Moreover, the authors are not even
> > > required to document what they are doing or to keep that behaviour
> > > consistent.
> > 
> > I thought my proposed solution was reasonable - add explicit padding fields where there are holes in the structure, which would be unused by the kernel, but since they are defined fields the compiler is obligated to initialize them.
> 
> Is the presence of holes always apparent at the source code level?  Or is 
> it dependent on the compiler or target architecture?

It depends on target architecture.

This means doing a full review to add a named padding only for arches
that need it.



