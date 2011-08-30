Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751278Ab1H3CIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 22:08:38 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45807 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab1H3CIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 22:08:34 -0400
X-Sasl-enc: cc0QZUMeTBPiL3Y+DkMvmg0JURCo/znIyzoqJoxZuT5V 1314670113
Date: Mon, 29 Aug 2011 23:08:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Arnaud Lacombe <lacombar@gmail.com>, David Airlie <airlied@redhat.com>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, Pavel Ivanov <paivanof@gmail.com>,
        Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kbuild@vger.kernel.org
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
Message-ID: <20110830020828.GA14915@khazad-dum.debian.net>
References: <20110829141612.GB2025@gere.osrc.amd.com>
 <1790021880.1347470.1314632844694.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
 <20110829155501.GC2025@gere.osrc.amd.com>
 <CACqU3MVZek9TCcZEAbJXZqy9JZs3cbzNVJpwjOhS8OoKqH_YZQ@mail.gmail.com>
 <20110829171750.GD2025@gere.osrc.amd.com>
 <1314641813.2816.133.camel@twins>
 <20110829211439.GA4488@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829211439.GA4488@liondog.tnic>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Borislav Petkov wrote:
> So, hypothetically speaking, hpa suggested then that we could pass
> firmware blobs over the linked list setup_data thing in the real-mode
> kernel header and parse_setup_data() can look at them and map them
> somewhere later for the driver to find. This should be doable because
> you're only gonna need a handful of blobs for CPU ucode, network and GPU
> if the last is compiled in.
> 
> I wanted to take a serious look at that for the ucode loading, maybe I
> should try to shuffle some time for it...

It would be very useful, yes.

Alternatively, you could extend the initrd format to have a firmware
directory appended after the filesystem image.  ACPI is going to abuse
the initrd in just that way to override ACPI tables very soon (patches
have been already submitted to linux-acpi), so if a more structured and
extensible way to piggy-back early-init data in the initrd is needed, it
would be good to bring that to the table NOW.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
