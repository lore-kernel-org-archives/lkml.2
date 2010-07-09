Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab0GIRLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:11:03 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38694 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757154Ab0GIRLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:11:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=k/KOlb+3d3gamLSMW0KpfjjNZkYRBGj1bUDQeuKrpYip7UcUpbElYTlOtwyEMpDMoZ
         QzDd21rMFAN8UswgL7AUShxcqgHKmCudTSFPP5gqF0fBf0RrEANMx2BjrXAUMs7Dk3t0
         fYv9Q1I1NbAlhxGxLf6ixAtXLOhFboQCKEK1o=
MIME-Version: 1.0
In-Reply-To: <D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com>
References: <AANLkTimvsaoOm_QEUnvlZf2EKuiMpOr9PdQt_Ga0Z97D@mail.gmail.com>
	<20100708012120.GB11419@auslistsprd01.us.dell.com>
	<D3F292ADF945FB49B35E96C94C2061B90C317EA2@nsmail.netscout.com>
	<82tyo9i0n2.fsf@mid.bfk.de>
	<D3F292ADF945FB49B35E96C94C2061B90C3CF3E9@nsmail.netscout.com>
Date: Fri, 9 Jul 2010 10:10:58 -0700
Message-ID: <AANLkTik4JOoNFSoML98j8LPJhJjVpWd8om-OYMGp3s9V@mail.gmail.com>
Subject: Re: nic enumeration
From: Steve Fink <sphink@gmail.com>
To: "Loke, Chetan" <Chetan.Loke@netscout.com>
Cc: Florian Weimer <fweimer@bfk.de>, linux-net@vger.kernel.org,
       Matt Domsch <Matt_Domsch@dell.com>,
       Michael Di Domenico <mdidomenico4@gmail.com>,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 9:27 AM, Loke, Chetan <Chetan.Loke@netscout.com> wrote:
> Ok, no renaming, I would like a reference. And symlink just doesn't work
> w/ the udevadm trigger business. We've tried that already.
>
> What needs to be changed in udev etc to create a soft link? Any place
> where I should start digging and gotchas to lookout for?

By "soft link", I assume you're talking figuratively? Soft (symbolic)
links are a filesystem concept, implemented by filesystem-specific
logic that knows how to read a filename out of an inode and restart
lookup. In order for something similar to work for network devices,
somebody would have had to explicitly implement similar functionality.
(Symlinks are a big headache and source of security holes -- access
control, loops, pointing to nonexistent files, etc. -- so there's a
good reason to NOT have an equivalent for network devices.)

But perhaps there *is* an equivalent: what about (ab)using bridges?
Create a set of bridges and bind each one to a single NIC. You can
name the bridges whatever you want, and set up the mapping through
arbitrary logic.
