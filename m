Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab2JUL7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 07:59:42 -0400
Received: from smtprelay0129.b.hostedemail.com ([64.98.42.129]:46772 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753285Ab2JUL7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 07:59:39 -0400
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::,RULES_HIT:152:355:379:541:582:599:601:966:967:988:989:1152:1260:1277:1311:1313:1314:1345:1358:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2525:2553:2560:2563:2682:2685:2857:2859:2901:2933:2937:2939:2942:2945:2947:2951:2954:3022:3027:3138:3139:3140:3141:3142:3167:3302:3353:3622:3865:3866:3867:3868:3869:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4385:5007:6119:6261:7679:7903:8599:9025:9388:9517:10004:10049:10400:10471:10848:11658:11914:12043:12292:12350:12517:12519:12682:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:omf07|3896350464|6DCC70A
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Filterd-Recvd-Size: 2785
Date: Sun, 21 Oct 2012 11:59:36 +0000 (GMT)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: bp@alien8.de
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org
Message-ID: <121566322.100103.1350820776893.JavaMail.mail@webmail20>
References: <2104474742.26357.1350734815286.JavaMail.mail@webmail05>
 <20121020162759.GA12551@liondog.tnic>
 <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020203227.GC555@elf.ucw.cz> <20121020225849.GA8976@liondog.tnic>
 <1781795634.31179.1350774917965.JavaMail.mail@webmail04>
 <20121021002424.GA16247@liondog.tnic>
 <1798605268.19162.1350784641831.JavaMail.mail@webmail17>
 <20121021110851.GA6504@liondog.tnic>
Subject: Re: Re: Re: Re: Re: A reliable kernel panic (3.6.2) and system
 crash when visiting a particular website
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: Webmail
X-Originating-IP: [46.146.77.234]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 21, 2012, Borislav Petkov wrote:
>
> On Sun, Oct 21, 2012 at 01:57:21AM +0000, Artem S. Tashkinov wrote:
> > The freeze happens on my *host* Linux PC. For an experiment I decided
> > to check if I could reproduce the freeze under a virtual machine - it
> > turns out the Linux kernel running under it also freezes.
>
> I know that - but a freeze != oops - at least not necessarily. Which
> means it could very well be a different issue now that vbox is gone.
>
> Or, it could be the same issue with different incarnations: with vbox
> you get the corruptions and without it, you get the freezes. I'm
> assuming you do the same flash player thing in both cases?
>
> Here's a crazy idea: can you try to reproduce it in KVM?

OK, dismiss VBox altogether - it has a very buggy USB implementation, thus
it just hangs when trying to access my webcam.

What I've found out is that my system crashes *only* when I try to enable
usb-audio (from the same webcam) - I still have no idea how to capture a
panic message, but I ran

"while :; do dmesg -c; done" in xterm, then I got like thousands of messages
and I photographed my monitor:

http://imageshack.us/a/img685/9452/panicz.jpg

list_del corruption. prev->next should be ... but was ...

I cannot show you more as I have no serial console to use :( and the kernel
doesn't have enough time to push error messages to rsyslog and fsync
/var/log/messages
