Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab1KIUOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 15:14:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580Ab1KIUOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 15:14:11 -0500
Date: Wed, 9 Nov 2011 18:13:37 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jim Paris <jim@jtan.com>
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
Message-ID: <20111109201337.GH18207@ghostprotocols.net>
References: <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com> <20111108143228.GC14272@ghostprotocols.net> <4EB94D08.3010207@redhat.com> <20111109085120.GD11473@elte.hu> <4EBA5881.7080409@redhat.com> <20111109115502.GA18207@ghostprotocols.net> <20111109192509.GA22581@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111109192509.GA22581@psychosis.jim.sh>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 09, 2011 at 02:25:09PM -0500, Jim Paris escreveu:
> Arnaldo Carvalho de Melo wrote:
> > Em Wed, Nov 09, 2011 at 11:40:01AM +0100, Gerd Hoffmann escreveu:
> > > As far I know it is pretty much impossible to figure the
> > > foreground/background colors of the terminal you are running on.  You

> > Glad to hear that, I thought I hadn't researched that much (I did). Hope
> > somebody appears and tell us how it is done :-)

> In xterm, '\e]10;?\e\\' and '\e]11;?\e\\' will report the colors, e.g.:

> #!/bin/bash
>   read -s -r -d \\ -p `printf '\e]10;?\e\\'` -t 1 fg
>   [ $? -ne 0 ] && fg="no response"
>   echo "foreground: $fg" | cat -v
>   read -s -r -d \\ -p `printf '\e]11;?\e\\'` -t 1 bg
>   [ $? -ne 0 ] && bg="no response"
>   echo "background: $bg" | cat -v

gnome-terminal:

[acme@felicio ~]$ ./a.sh
foreground: no response
background: no response
[acme@felicio ~]$

:-(

- Arnaldo
