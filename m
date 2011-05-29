Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab1E2Hdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 03:33:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61724 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1E2Hdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 03:33:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vNagd8NbweKSvaHUjVx+ZlKg7v6149FKlwDRVcSD2fD9S7UJMNoUiutdxkbsRpcbtn
         8olKcsR283Uj98nhIDn1tAONpYIIvH8txfQT46nwIqR+WCLBq7k8WyXG7Ls19ytCPyeZ
         QnlBS5PXJdZ21OWWijqKfsjXLit33MmV44mZY=
Subject: Re: Kernel crash after using new Intel NIC (igb)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arun Sharma <asharma@fb.com>, David Miller <davem@davemloft.net>,
        Maximilian Engelhardt <maxi@daemonizer.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>,
        Yann Dupont <Yann.Dupont@univ-nantes.fr>,
        Denys Fedoryshchenko <denys@visp.net.lb>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110528180434.GB12530@elte.hu>
References: <4DDEAA3C.7020502@fb.com>
	 <1306439246.2543.10.camel@edumazet-laptop> <4DDECA9B.8080206@fb.com>
	 <1306447292.2543.32.camel@edumazet-laptop> <4DDEEBC5.80804@fb.com>
	 <1306466831.2543.58.camel@edumazet-laptop> <4DDFE4D6.4010000@fb.com>
	 <1306526219.2533.3.camel@edumazet-laptop>
	 <20110527211419.GA6793@dev1756.snc6.facebook.com>
	 <1306561285.2533.9.camel@edumazet-laptop>  <20110528180434.GB12530@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 29 May 2011 09:33:44 +0200
Message-ID: <1306654424.30021.7.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 28 mai 2011 à 20:04 +0200, Ingo Molnar a écrit :
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > > +static inline int atomic_add_unless(atomic_t *v, int a, int u)
> > > +{
> > > +	return __atomic_add_unless(v, a, u) != u;
> > >  }
> > >  
> > >  #define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
> > 
> > As I said, atomic_add_unless() has several implementations in 
> > various arches. You must take care of all, not only x86.
> 
> It's a bit sad to see local hacks to generic facilities committed 
> upstream like that.
> 

Again, its a stable candidate patch, on a file that had many changes in
recent kernels.

I felt this was the right thing to do, to ease stable teams work.

Its not like there is an urgent need for this atomic_add_unless_return()
thing that we have to worry right now.



