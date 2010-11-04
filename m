Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0KDScK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 14:32:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60659 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345Ab0KDScI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 14:32:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RUdBNbguk2s3Gnyz61+xFOXGfSispykONTitjLeI3SU0nKiM7gyHE+DYj4ULNSixss
         TJGi7ai3uDsDNuuZEXcbMRpN3nJDxBYVs1cQkUQd7YVugspId6HlcGlC9ntgov3qxCzC
         hbDG3HhPfPrlawtcajjzSrUKqkkgqBZeyVPjg=
MIME-Version: 1.0
In-Reply-To: <4CD2F735.2040903@redhat.com>
References: <20101009224041.GA901@sepie.suse.cz>
	<4CD1E232.30406@redhat.com>
	<AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>
	<4CD22627.2000607@redhat.com>
	<AANLkTi=Eb8k6gmeGqvC=Zbo2mj51oHcbCncZGt00u9Tx@mail.gmail.com>
	<4CD29493.5020101@redhat.com>
	<20101104101910.920efbed.randy.dunlap@oracle.com>
	<4CD2F735.2040903@redhat.com>
Date: Thu, 4 Nov 2010 14:32:07 -0400
Message-ID: <AANLkTikx+RkV82Cb1YQfYNzVWpMqRQOnvhNY4LtS64FC@mail.gmail.com>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 4, 2010 at 2:11 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> [...]
> Yes, but this makes things worse: it will allow compiling drivers that Kernel
> will never use, as they won't work without an I2C adapter, and the I2C adapter
> is not compiled.
>
> Worse than that: if you go into all V4L bridge drivers, that implements the I2C
> adapters and disable them, the I2C ancillary adapters will still be compiled
> (as they won't return to 'n'), but they will never ever be used...
>
> So, no, this is not a solution.
>
> What we need is to prompt the menu only if the user wants to do some manual configuration.
> Otherwise, just use the selects done by the drivers that implement the I2C bus adapters,
> and have some code to use those selected I2C devices.
>
These is an easy solution: doing as
`Documentation/kbuild/kconfig-language.txt' say it should be done:

config MODULES
        bool "modules ?"
        default y

config AUTO
        bool "AUTO"

config IVTV
        tristate "IVTV"
        select WM42 if AUTO

menu "TV"
        depends on !AUTO

config WM42_USER
        tristate "WM42"
        select WM42

endmenu

config WM42
        tristate
        default n

 - Arnaud
