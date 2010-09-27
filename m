Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab0I0VRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 17:17:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47363 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032Ab0I0VRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 17:17:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nigel Cunningham <nigel@tuxonice.net>
Subject: Re: [PATCH 02/23] Record & display i/o speed post resume.
Date: Mon, 27 Sep 2010 23:16:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "TuxOnIce-devel" <tuxonice-devel@tuxonice.net>
References: <1285566238-10966-1-git-send-email-nigel@tuxonice.net> <201009272249.59966.rjw@sisk.pl> <4CA10729.5010001@tuxonice.net>
In-Reply-To: <4CA10729.5010001@tuxonice.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201009272316.30718.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 27, 2010, Nigel Cunningham wrote:
> Hi.
> 
> On 28/09/10 06:49, Rafael J. Wysocki wrote:
> > On Monday, September 27, 2010, Nigel Cunningham wrote:
...
> >> Well then, for now, let's drop that patch then. At least it's got us the
> >> numbers we needed to see these patches are useful. Longer term, I'll do
> >> what I do in TuxOnIce and allocate a page while writing the image, store
> >> it's location in the image header and use it the transfer information
> >> from the boot kernel to the resumed kernel. (Essentially the same thing,
> >> except without the special section).
> >
> > The problem is that on x86_64 the boot kernel may be completely different
> > from the image kernel (different version, different configuration), so there is
> > no guarantee that your page frame allocated while writing the image would be
> > available to the boot kernel (it may contain the kernel code, for example).
> >
> > You'd really need to replace one of the image pages with  something prepared
> > while the image was being read.  For that, you'd need to allocate a page before
> > creating the image and pass its PFN in the image header.
> 
> Yes - that's what I'm doing. Maybe that's why the __nosavedata changes 
> you mentioned above haven't bitten me.

Well, other than that, the majority of people don't know about that change and
they still use the same kernel for boot/image. :-)

Thanks,
Rafael
