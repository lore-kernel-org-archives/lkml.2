Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965349Ab2EXWFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:05:32 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49547 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab2EXWFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:05:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120524220105.GB18120@kroah.com>
References: <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
 <20120524180154.GA15036@core.coreip.homeip.net> <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
 <20120524195851.GA15306@core.coreip.homeip.net> <CA+55aFxX+xidcuVXb1h4oFTemtHo+ANECaoOw=vxtKN231N+cA@mail.gmail.com>
 <20120524203647.GA16024@core.coreip.homeip.net> <CA+55aFz9Fp2J=oCkoDAwNTnEJoBeKC9tn+5dqMCKf4C22CAi6Q@mail.gmail.com>
 <20120524205952.GA16621@core.coreip.homeip.net> <CA+55aFybQDXjGaEK0k=60gS88bxwE8vC7XvOffaQAf3de9cCfg@mail.gmail.com>
 <CA+55aFzZm2aAhgZagWq=rsfKTt=2_2_mpVjXDN3LAqAJmWoZqw@mail.gmail.com> <20120524220105.GB18120@kroah.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 May 2012 15:05:09 -0700
X-Google-Sender-Auth: iGvPektaATDeW3P0ymu91WivAiQ
Message-ID: <CA+55aFxYQQRpw0CDJn8bRLQJ2EYNhxf4Ra6=Hd9hOw=1q11pXA@mail.gmail.com>
Subject: Re: [git pull] Input updates for 3.5-rc0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 3:01 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> I'm open to ideas on what to change it to.  A full sysfs path?

A full sysfs path really looks pretty ugly, partly because we'd have
to really change all our naming (look at PCI devices now: they end up
looking like

    pci0000:00/0000:00:1a.0

where that "0000:00" is duplicated because we wanted to make
dev_name() look nice).

I think Dmitry's idea to stop when we hit the actual "physical" device
might just work in practice. So we'd show the dev_name() of the actual
piece of hardware, and then perhaps one or two "layering" details on
top of it. And it wouldn't change anything for the current common case
where people tend to pass in the physical device as-is.

                     Linus
