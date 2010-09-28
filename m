Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759936Ab0I1AtJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 20:49:09 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58509 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab0I1AtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 20:49:08 -0400
X-Originating-Ip: 216.16.235.2
Date: Mon, 27 Sep 2010 20:48:55 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ext3 filesystem corruption in user mode linux
Message-ID: <20100928004855.GA28669@foursquare.net>
References: <20100924060557.GA21238@foursquare.net> <20100924064446.GA22588@foursquare.net> <AANLkTinQ20uSgFP5KV17B0J0v8Y0zAg=AgAd_kf+4Bh0@mail.gmail.com> <20100927211842.GA19667@foursquare.net> <AANLkTinYjJ8m6UjsR++zFCxo4jecDEzCAX_F_CF6NwZV@mail.gmail.com> <20100927212650.GA20386@foursquare.net> <20100927215941.GA20458@foursquare.net> <AANLkTinmCxYrjdYoDUE6+zg1i1QSJxt5ngN84FrjWJaj@mail.gmail.com> <20100927221225.GA22343@foursquare.net> <AANLkTi=iSSffp-48g0XAOYBSnodAsEh20j2EtHW=4Egt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=iSSffp-48g0XAOYBSnodAsEh20j2EtHW=4Egt@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 28, 2010 at 01:35:09AM +0200, richard -rw- weinberger wrote:
> On Tue, Sep 28, 2010 at 12:12 AM, Chris Frey <cdfrey@foursquare.net> wrote:
> > I'm using a mixture of the following to test.  The errors happen
> > during the 'rm'.
> >
> >        Direct copy:
> >                (cd dir && tar cjf - portage) | tar xjf - ; rm -rf portage
> >
> >        Hostfs copy:
> >                tar xjf /mnt/hostfs/portage-latest.tar.bz2 ; rm -rf portage
> >
> >        Network copy:
> >                ssh remote "cat portage-latest.tar.bz2" | tar xjf - ; rm -rf portage
> >
> > With these tests, I'm almost guessing that it might be some missed IRQs
> > or something in the guest, since files that are corrupt often contain
> > all zeros, which would match the sparse filesystem images I'm using.
> 
> Hmm, something really nasty is going one here.
> I can reproduce this issue using ext2, ext3 and reiserfs as UML root filesystem.
> It seems to be a block layer issue.
> Tomorrow I'll have a close look at the issue using my openSUSE setup.
> So far I've used your Gentoo image.

I've also seen the issue with a Ubuntu guest as well.  So far, I don't think
it matters what OS is in the guest.

Thanks for reproducing the error!
- Chris

