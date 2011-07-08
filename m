Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1GHQPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 12:15:41 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43768 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1GHQPk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 12:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <1310140451.3282.85.camel@mulgrave>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
 <20110708145408.GA2283@kroah.com> <CAPXgP10gThuxOsrxH8_wOddeRB5f2ABypW7EQui-F1hOE97dHQ@mail.gmail.com>
 <20110708154736.GA7320@kroah.com> <1310140451.3282.85.camel@mulgrave>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 8 Jul 2011 18:15:18 +0200
Message-ID: <CAPXgP12dA72a3ja659GH6uW+ZCMfL6iECaY6ORXwOQ6S5eTvaQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        jcm@redhat.com, dle-develop@lists.sourceforge.net,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com,
        stefanr@s5r6.in-berlin.de, hare@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 8, 2011 at 17:54, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:

> Yes, we did.  Everyone agrees structured logging would be the best long
> term solution.  However, it's at least 10x the work presented here, plus
> it would be a long process getting everyone to agree.

Maybe even 100 times :)

> This looks like a
> good 95% interim solution and it can be removed when structured logging
> makes everything "just work(tm)".

I don't really see that. I think it does not add any real value on top
of a simple udev logging at device discovery.

You would see that in the log:
  [78441.742634]: udevd: sdc: \
  disk/by-id/ata-INTEL_SSDSA1M080G2GN_CVPO0363030V080EGN \
  disk/by-id/scsi-SATA_INTEL_SSDSA1M08CVPO0363030V080EGN \
  disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0 \
  disk/by-id/wwn-0x50015179593f3038

and know exactly _all_ names and all identifiers of the disk at that time.

Then you see this:
  [78441.742634] storage: really bad things happened to: sdc

and with the earlier message we have all we need to know without any
pretty-name hacks.

All that can be done today already with a single udev rule, even on
many years old distros.

> I have also seen a couple of other attempts at structured logging which
> both failed when the people proposing the patches realised how much work
> it actually was, so I'm a bit sceptical we'll ever get there.

The more paper-over we add the more unlikely it gets. That's what I fear. :)

> But hey,
> you have the enthusiasm, propose it as a KS topic to get agreement that
> we should do it and what the format should be and we can go from there.

Sure, I'll do that. If needed, I can even make half or a third of it
possible I guess.

Thanks,
Kay
