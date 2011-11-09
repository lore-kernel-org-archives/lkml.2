Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab1KIKlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 05:41:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6903 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019Ab1KIKlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 05:41:08 -0500
Message-ID: <4EBA5881.7080409@redhat.com>
Date: Wed, 09 Nov 2011 11:40:01 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>, Theodore Tso <tytso@mit.edu>,
        Anthony Liguori <anthony@codemonkey.ws>,
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
Subject: Re: [F.A.Q.] the advantages of a shared tool/kernel Git	repository,
 tools/perf/ and tools/kvm/
References: <20111107203255.GF24234@thunk.org> <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com> <4EB85969.2010108@codemonkey.ws> <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com> <20111108143228.GC14272@ghostprotocols.net> <4EB94D08.3010207@redhat.com> <20111109085120.GD11473@elte.hu>
In-Reply-To: <20111109085120.GD11473@elte.hu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

> What we want to have is to have a set of distinctive colors - just 
> two (background, foreground) colors are not enough - we also need 
> colors to highlight certain information - we need 5-6 colors for the 
> output to be maximally expressive. Is there a canonical way to handle 
> that while still adapting to user preferences automatically by taking 
> background/foreground color scheme of the xterm into account?

> I suspect to fix the worst of the fallout we could add some logic to 
> detect low contrast combinations (too low color distance) and fall 
> back to the foreground/background colors in that case.

As far I know it is pretty much impossible to figure the
foreground/background colors of the terminal you are running on.  You
can try some guesswork based on $TERM (linux console usually has black
background, xterm is white by default), but there will always be cases
where it fails.

You can run without colors.  You can use bold to highlight things and
reverse for the cursor.  Surely a bit limited and not as pretty as
colored, but works for sure everywhere.

You can go for a linux-console style black background.  Pretty much any
color is readable here, so you should have no problems at all to find
the 5-6 colors you want.

You can go for a xterm-like light background, for example the lightgray
used by older perf versions.  I like that background color, problem is
with most colors the contrast is pretty low.  IMHO only red, blue and
violet are readable on lightgray.  And black of course.

> Plus allowing full .perfconfig configurability of all the relevant 
> colors, for those with special taste.

Sure.  Maybe also allow multiple color sections and pick them by $TERM
or --colors switch, i.e. [colors "xterm"].

cheers,
  Gerd
