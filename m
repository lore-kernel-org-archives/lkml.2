Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0GMOkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:40:32 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48053 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab0GMOka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:40:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=APo7G3FRjbbiNU9OdUY0Tt+YBWoX0pZfY8ol6LpAT1vYVNmiimcRr5AU/WJyvDL4Kz
         3EzGofpHJLt9OzLNVsPYF1Sg99hxpxnswI5cOptFB/f6y9mTBvmZPVz4gGekIN6qJqkp
         ekpNWKG9U2PHkMFd8OwdWvM6/1XH8JP+lLlp8=
Subject: Re: [PATCH] tproxy: nf_tproxy_assign_sock() can handle tw sockets
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Felipe W Damasio <felipewd@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, David Miller <davem@davemloft.net>,
        Patrick McHardy <kaber@trash.net>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTimn9x17g-4K7fS4MjmCgzHuBARurEoFVd_gId7m@mail.gmail.com>
References: <AANLkTimn8A0cYZmwNZYitRkBHKKFe4HQ5GU626DLugkk@mail.gmail.com>
	 <AANLkTil49m6Ul2bauiH4Pwn-6ykrYTFmSO6_SxqQgD_e@mail.gmail.com>
	 <1278626921.2435.73.camel@edumazet-laptop>
	 <AANLkTiliBClahTfb41M5BDi1etg5pgkqEz_VfGrn_mK4@mail.gmail.com>
	 <1278695580.2696.55.camel@edumazet-laptop>
	 <AANLkTil39xHOhcdAo4h_jWtx_UuYdFHGdQVAdwPMd7QJ@mail.gmail.com>
	 <1278742649.2538.17.camel@edumazet-laptop> <4C395459.6080407@redhat.com>
	 <1278835332.2538.51.camel@edumazet-laptop>
	 <AANLkTikEGuFtTlIKUfti6GDsdBz99PpKRCs5lEeEM86u@mail.gmail.com>
	 <AANLkTilbEkJWPqvJE72r9HdFQSU84S02BKZB0CH-8QwB@mail.gmail.com>
	 <AANLkTimn9x17g-4K7fS4MjmCgzHuBARurEoFVd_gId7m@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 16:40:23 +0200
Message-ID: <1279032023.2634.384.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 juillet 2010 à 11:24 -0300, Felipe W Damasio a écrit :
> Hi Mr. Dumazet,
> 
> 2010/7/12 Felipe W Damasio <felipewd@gmail.com>:
> > Here's the result using ethtool-2.6.34:
> >
> > ./ethtool -k eth1
> >
> > Offload parameters for eth1:
> > rx-checksumming: on
> > tx-checksumming: on
> > scatter-gather: on
> > tcp-segmentation-offload: on
> > udp-fragmentation-offload: off
> > generic-segmentation-offload: on
> > generic-receive-offload: off
> > large-receive-offload: off
> > ntuple-filters: off
> > receive-hashing: off
> >
> >
> > ./ethtool -k eth2
> >
> > Offload parameters for eth2:
> > rx-checksumming: on
> > tx-checksumming: on
> > scatter-gather: on
> > tcp-segmentation-offload: on
> > udp-fragmentation-offload: off
> > generic-segmentation-offload: on
> > generic-receive-offload: off
> > large-receive-offload: off
> > ntuple-filters: off
> > receive-hashing: off
> 
> Did these help you track down the issue?
> 
> Sorry to insist, it's just that my bosses are kind of pressuring me to
> solve the problem and put the squid machine back online :-)
> 
> Is there a test I can run to try and trigger the issue?
> 
> I have the same scenario (hardware and network setup) on my lab...
> 

I currently have no fresh ideas. If you want this problem to be solved,
its important to setup in your lab a workload to trigger again and again
the bug, in order to provide us more crash information.

After code review doesnt spot obvious bugs, this is time for brute force
hunting, using git bisection for example...



