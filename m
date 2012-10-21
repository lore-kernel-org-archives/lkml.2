Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2JUUgx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 16:36:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36857 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab2JUUgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 16:36:51 -0400
Date: Sun, 21 Oct 2012 22:36:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: pavel@ucw.cz, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, linux-media@vger.kernel.org,
        linux-usb@vger.kernel.org, zonque@gmail.com,
        alsa-devel@alsa-project.org, stern@rowland.harvard.edu
Subject: Re: Re: Re: Re: Re: Re: A reliable kernel panic (3.6.2) and system
 crash when visiting a particular website
Message-ID: <20121021203647.GA13365@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Artem S. Tashkinov" <t.artem@lycos.com>, pavel@ucw.cz,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	security@kernel.org, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, zonque@gmail.com,
	alsa-devel@alsa-project.org, stern@rowland.harvard.edu
References: <966148591.30347.1350754909449.JavaMail.mail@webmail08>
 <20121020203227.GC555@elf.ucw.cz>
 <20121020225849.GA8976@liondog.tnic>
 <1781795634.31179.1350774917965.JavaMail.mail@webmail04>
 <20121021002424.GA16247@liondog.tnic>
 <1798605268.19162.1350784641831.JavaMail.mail@webmail17>
 <20121021110851.GA6504@liondog.tnic>
 <121566322.100103.1350820776893.JavaMail.mail@webmail20>
 <20121021170315.GB20642@liondog.tnic>
 <1906833625.122006.1350848941352.JavaMail.mail@webmail16>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1906833625.122006.1350848941352.JavaMail.mail@webmail16>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 07:49:01PM +0000, Artem S. Tashkinov wrote:
> I ran it this way: while :; do dmesg -c; done | scat /dev/sda11 (yes,
> straight to a hdd partition to eliminate a FS cache)

Well, I'm no fs guy but this should still go through the buffer cache. I
think the O_SYNC flag makes sure it all lands on the partition in time.
Oh well, it doesn't matter.

> Don't judge me harshly - I'm not a programmer.

If you wrote that and you're not a programmer, it certainly looks cool,
good job!.

 [ Btw, don't forget to free(buffer) at the end. ]

Also, there was a patchset recently which added a blockconsole method to
the kernel with which you can do something like that in a generic way.

Back to the issue at hand: it looks like ehci_hcd is causing some list
corruptions, maybe coming from the uvcvideo or whatever. I think the usb
people will have a better idea.

Btw, is there any particular reason you're running a 32-bit kernel?

Thanks.

-- 
Regards/Gruss,
    Boris.
