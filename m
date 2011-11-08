Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab1KHPjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 10:39:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab1KHPjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 10:39:20 -0500
Message-ID: <4EB94D08.3010207@redhat.com>
Date: Tue, 08 Nov 2011 16:38:48 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110927 Red Hat/3.1.15-1.el6_1 Thunderbird/3.1.15
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
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
References: <alpine.DEB.2.02.1111071156230.28615@pianoman.cluster.toy> <CAOJsxLEfapPPU8cEfeCMq9_oG6858YzFS_fkWQEo_fxs+xde9A@mail.gmail.com> <20111107203255.GF24234@thunk.org> <CAOJsxLEKx5M5L_N42pQpo2hcNhseQKhUo6CXAyQHesJRWFASKQ@mail.gmail.com> <4EB85969.2010108@codemonkey.ws> <12F471C8-2CF3-4CD7-B417-C8CC898669E6@mit.edu> <20111108093225.GB32533@elte.hu> <EDBAFB6F-4E3B-42B0-93E6-DF162B9859A6@mit.edu> <20111108125609.GA14272@ghostprotocols.net> <4EB9315A.10806@redhat.com> <20111108143228.GC14272@ghostprotocols.net>
In-Reply-To: <20111108143228.GC14272@ghostprotocols.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

>> documentation:  Where the heck is the perf config file documented, other
>> than source code?  Reading the parser to figure how the config file is
>> supposed to look like really isn't fun :(
>  
>> I'm looking for a way to disable the colors in the perf report tui.  Or
>> configure them into something readable.  No, light green on light gray
>> which is used by default isn't readable.
> 
> That was fixed in 3.2-rc1, where also we have:

Very cutting edge.  /me pulls.

> [acme@felicio linux]$ cat tools/perf/Documentation/perfconfig.example

Present now, thanks.

> [colors]
> 
> 	# These were the old defaults
> 	top = red, lightgray
> 	medium = green, lightgray
> 	normal = black, lightgray
> 	selected = lightgray, magenta
> 	code = blue, lightgray

Seems to have no effect, guess the distro perf binary is too old for
that (RHEL-6).

> [tui]
> 
> 	report = off

That works.  I don't want turn off the tui altogether though, I actually
like the interactive expanding+collapsing of the call graphs.  I just
want turn off the colors.

perf_color_default_config() in util/color.c seems to lookup a "color.ui"
config variable.  Can I set that somehow?  Tried ui= in a [color]
section -- no effect.

> By default the TUI now uses whatever color is configured for your xterm,
> not something fixed as in the past, which was a common source of
> complaints, that, unfortunately I only heard indirectly :-\
> 
> Ah, if you still need to configure the colors, use "default" so that it
> will use whatever is the color configured in your
> xterm/gnome-terminal/whatever profile.
> 
> For reference, the default set of colors now is (from
> tools/perf/util/ui/browser.c):
> 
> static struct ui_browser__colorset {
>         const char *name, *fg, *bg;
>         int colorset;
> } ui_browser__colorsets[] = {
>         {
>                 .colorset = HE_COLORSET_TOP,
>                 .name     = "top",
>                 .fg       = "red",
>                 .bg       = "default",

Bad idea IMO.  Setting only one of foreground+background gives pretty
much unpredictable results.  My xterms have different background colors,
the ones with a root shell happen to have a (dark) red background.
Which results in red-on-dark-red text.  Not good.

I'd strongly suggest to either set both background and foreground to
default or to set both to a specific color.  When doing the latter make
sure the colors have enougth contrast so they are readable.

cheers,
  Gerd
