Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab0HHAjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 20:39:16 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52642 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0HHAjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 20:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RB5FRJ6+QGrFtiYGM3EJcrPVYLbOF2L09VM5toUicr65YxWo7mS0+qJv4d85y6sVlV
         Ch4V+cyIEJNMdja+j20rNH0VY5zVMeESpBymAtbM0f92XiNPNL2LL47yrNpfCJligBiQ
         1mRVAvWoochWJqWeU+XFB83Nph9ng0upkrdcU=
Date: Sun, 8 Aug 2010 04:38:46 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tty_io: add an API to get device corresponding to
 tty_struct
Message-ID: <20100808003846.GA9123@doriath.ww600.siemens.net>
References: <20100806165844.GB3364@suse.de>
 <1281174902-6298-1-git-send-email-dbaryshkov@gmail.com>
 <20100807123333.614169f1@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807123333.614169f1@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 12:33:33PM +0100, Alan Cox wrote:
> On Sat,  7 Aug 2010 13:55:02 +0400
> Dmitry Eremin-Solenikov <dbaryshkov@gmail.com> wrote:
> 
> > Some device drivers (mostly tty line disciplines) would like to have way
> > to get a struct device instancve corresponding to passed tty_struct. Add
> > respective API call.
> 
> Most of the kernel simply keeps a parent device pointer in the struct. If
> we have a lookup method then we'll simply end up with a struct device in
> each tty ldisc struct instead, and it will be harder to clean up later.

The proposed usage (at least what we did in the second patch and what
I did in IEEE 802.15.4 tty driver) is to use this device pointer to
set up parent node for all devices created on top of given tty port.

> I think I'd much rather see this set when the tty is created and always
> available. That would also let the whole tty layer use dev_err() and
> friends usefully ?

I was afraid of messing with tty layer in such way, as it's a bit too
complex for me.

Do you mean adding struct device pointer to struct tty_struct (easy),
or refactoring code so, that struct tty_struct contains embedded
struct device and uses it for refcounting & stuff?

-- 
With best wishes
Dmitry

