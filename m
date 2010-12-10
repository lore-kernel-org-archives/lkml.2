Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0LJQeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:34:50 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:32926 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab0LJQet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:34:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=jUbmDTMrzFM/mItrUMuCul2pfdXwtxyXOernoW2qL8xVQ504jzhTmOM8UibRKZHLV4
         e0RnZFcanO2qQx8QCLaJanb4cfaf09P1krQhMtkpqWrZ2LSD42sdr91fQamIEquKC7h8
         PlALpUsWqMDaVxXoKwPBf8eHoRw82u8Y2sQGQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com>
References: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com>
From: Daniel Drake <dsd@laptop.org>
Date: Fri, 10 Dec 2010 16:34:47 +0000
X-Google-Sender-Auth: SdBPgaKA9B5WuVPkQJkYjg--5oA
Message-ID: <AANLkTim5U++eXD96D6H_CjrH7HFwsrRnA+bGz_1MCNP8@mail.gmail.com>
Subject: Re: MFD cell structure and sharing of resources
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Fox <pgf@laptop.org>, Andres Salomon <dilinger@queued.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2010 15:37, Daniel Drake <dsd@laptop.org> wrote:
> 3. For olpc-xo1-pm and olpc-xo1-sci, forget about hooking into MFD and
> go back to the route of looking for the appropriate device on the PCI
> bus and accessing the regions that way.

That isn't really an option either, because pci_request_region makes
the region exclusive to 1 device.
However, something similar is possible: olpc-xo1-pm reserves the
region and makes it enable to olpc-xo1-sci through an exported symbol.

Daniel
