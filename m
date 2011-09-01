Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab1IAWQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:16:55 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:33839 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab1IAWQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:16:54 -0400
Date: Thu, 1 Sep 2011 17:16:48 -0500
From: scameron@beardog.cce.hp.com
To: Jon Mason <mason@myri.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephenmcameron@gmail.com,
        thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-pci@vger.kernel.org, Roland Dreier <roland@purestorage.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        scameron@beardog.cce.hp.com
Subject: Re: [BUG] scsi: hpsa: how to destroy your files
Message-ID: <20110901221648.GR9189@beardog.cce.hp.com>
References: <1314890642.2823.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <20110901160724.GN9189@beardog.cce.hp.com> <1314898815.2823.33.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CAL1RGDWu4mBE3=0BC3iNnvfSSuT2pfGrXsBZBU-VB+tqZx7DeA@mail.gmail.com> <1314903038.3067.27.camel@dabdike> <20110901125938.7cb1da85@jbarnes-desktop> <20110901200349.GO9189@beardog.cce.hp.com> <20110901130930.5caec2d4@jbarnes-desktop> <20110901204419.GY8422@beardog.cce.hp.com> <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMaF-rOG9gNf3g8rOXiKMq3TXrfJf5dFwN6q6uQqvMruUm4VQg@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 04:50:45PM -0500, Jon Mason wrote:
> On Thu, Sep 1, 2011 at 3:44 PM,  <scameron@beardog.cce.hp.com> wrote:
> > On Thu, Sep 01, 2011 at 01:09:30PM -0700, Jesse Barnes wrote:
> >> On Thu, 1 Sep 2011 15:03:49 -0500
> >> scameron@beardog.cce.hp.com wrote:
> >>
> >> > On Thu, Sep 01, 2011 at 12:59:38PM -0700, Jesse Barnes wrote:
> >> > > On Thu, 01 Sep 2011 11:50:38 -0700
> >> > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> >> > >
> >> > > > On Thu, 2011-09-01 at 10:58 -0700, Roland Dreier wrote:
> >> > > > > > OK I found the bad commit,I got lucky... I lost some files but my
> >> > > > > > machine was able to complete the bisection. CC involved people
> >> > > > >
> >> > > > > > # bad: [b03e7495a862b028294f59fc87286d6d78ee7fa1] PCI: Set PCI-E Max Payload Size on fabric
> >> > > > >
> >> > > > > Hi Eric,
> >> > > > >
> >> > > > > I guess it would be useful to see "lspci -vv" output with a "good" kernel
> >> > > > > and with that bad patch applied.  Most likely we should see some difference
> >> > > > > somewhere in the MaxPayload fields in the PCI Express capability of
> >> > > > > some device.
> >> > > > >
> >> > > > > Either the RAID controller or something else lies, and puts a value
> >> > > > > in the DevCap that it can't actually support, or else the patch is
> >> > > > > buggy and puts something out of range in a DevCtl somewhere.
> >> > > >
> >> > > >
> >> > > > While we investigate, I think the problems produced by the patch (data
> >> > > > corruption) are serious enough to warrant reverting it, please Jesse.
> >> > >
> >> > > Hm I haven't been paying attention to the compromise thread; how should
> >> > > I share these changes?  Is master.kernel.org down indefinitely?  Is
> >> > > there a new server at kernel.org I can use?
> >> >
> >> > I can't answer that question, but I would like a copy of your revert
> >> > patch(es) to test (as a simple patch --reverse of the original commit on the 3.1-rc4
> >> > tree didn't go in cleanly).
> >>
> >> Attached is the series.  Applies on top of my for-linus branch.
> >
> > Thanks.  I tried them out vs. 3.1-rc4, and they applied cleanly and
> > make things work on my BL460g7.
> 
> I believe modifying the MRRS values is what is causing the issues.
> Can you try the attached patch and verify that it also resolves the
> issue?

Ok, just tried it.

The mrrs_removal patch does also appear to resolve the issue.

Thanks.

-- steve
