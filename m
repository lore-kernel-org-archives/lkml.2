Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab1KJIjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:39:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932141Ab1KJIjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:39:49 -0500
Message-ID: <4EBB8DA4.1080907@redhat.com>
Date: Thu, 10 Nov 2011 09:39:00 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Jim Paris <jim@jtan.com>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Theodore Tso <tytso@mit.edu>, Anthony Liguori <anthony@codemonkey.ws>,
        Pekka Enberg <penberg@kernel.org>, Vince Weaver <vince@deater.net>,
        Avi Kivity <avi@redhat.com>,
        "kvm@vger.kernel.org list" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        qemu-devel Developers <qemu-devel@nongnu.org>,
        Alexander Graf <agraf@suse.de>, Blue Swirl <blauwirbel@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git repository,
 tools/perf/ and tools/kvm/
References: <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com> <20111108143228.GC14272@ghostprotocols.net> <4EB94D08.3010207@redhat.com> <20111109085120.GD11473@elte.hu> <4EBA5881.7080409@redhat.com> <20111109115502.GA18207@ghostprotocols.net> <20111109192509.GA22581@psychosis.jim.sh>
In-Reply-To: <20111109192509.GA22581@psychosis.jim.sh>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

>>> As far I know it is pretty much impossible to figure the
>>> foreground/background colors of the terminal you are running on.  You
>>
>> Glad to hear that, I thought I hadn't researched that much (I did). Hope
>> somebody appears and tell us how it is done :-)
> 
> In xterm, '\e]10;?\e\\' and '\e]11;?\e\\' will report the colors, e.g.:
> 
> #!/bin/bash
>   read -s -r -d \\ -p `printf '\e]10;?\e\\'` -t 1 fg
>   [ $? -ne 0 ] && fg="no response"
>   echo "foreground: $fg" | cat -v
>   read -s -r -d \\ -p `printf '\e]11;?\e\\'` -t 1 bg
>   [ $? -ne 0 ] && bg="no response"
>   echo "background: $bg" | cat -v

Works fine in xterm.  Neither gnome-terminal (i.e. vte widget) nor
konsole support this though.

cheers,
  Gerd
