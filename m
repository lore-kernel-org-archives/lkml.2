Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab1KITeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:34:04 -0500
Received: from jim.sh ([75.150.123.25]:52695 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab1KITeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:34:01 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Nov 2011 14:34:01 EST
Date: Wed, 9 Nov 2011 14:25:09 -0500
From: Jim Paris <jim@jtan.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Theodore Tso <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git
 repository, tools/perf/ and tools/kvm/
Message-ID: <20111109192509.GA22581@psychosis.jim.sh>
References: <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu>
 <20111108093225.GB32533@elte.hu>
 <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu>
 <20111108125609.GA14272@ghostprotocols.net>
 <4EB9315A.10806@redhat.com>
 <20111108143228.GC14272@ghostprotocols.net>
 <4EB94D08.3010207@redhat.com>
 <20111109085120.GD11473@elte.hu>
 <4EBA5881.7080409@redhat.com>
 <20111109115502.GA18207@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109115502.GA18207@ghostprotocols.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Wed, Nov 09, 2011 at 11:40:01AM +0100, Gerd Hoffmann escreveu:
> >   Hi,
> > 
> > > What we want to have is to have a set of distinctive colors - just 
> > > two (background, foreground) colors are not enough - we also need 
> > > colors to highlight certain information - we need 5-6 colors for the 
> > > output to be maximally expressive. Is there a canonical way to handle 
> > > that while still adapting to user preferences automatically by taking 
> > > background/foreground color scheme of the xterm into account?
> > 
> > > I suspect to fix the worst of the fallout we could add some logic to 
> > > detect low contrast combinations (too low color distance) and fall 
> > > back to the foreground/background colors in that case.
> > 
> > As far I know it is pretty much impossible to figure the
> > foreground/background colors of the terminal you are running on.  You
> 
> Glad to hear that, I thought I hadn't researched that much (I did). Hope
> somebody appears and tell us how it is done :-)

In xterm, '\e]10;?\e\\' and '\e]11;?\e\\' will report the colors, e.g.:

#!/bin/bash
  read -s -r -d \\ -p `printf '\e]10;?\e\\'` -t 1 fg
  [ $? -ne 0 ] && fg="no response"
  echo "foreground: $fg" | cat -v
  read -s -r -d \\ -p `printf '\e]11;?\e\\'` -t 1 bg
  [ $? -ne 0 ] && bg="no response"
  echo "background: $bg" | cat -v

-jim
