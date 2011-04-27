Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab1D0WmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:42:05 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28227 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760133Ab1D0WmC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:42:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=seMliQ43Zp9XtWGo737US9PSZfo8dG+jBHs8FUFd1T+Ir50Fd0QPXR4wXYaRrvVAp5
         4HwBRKXXKDzcxf8X/WTA==
MIME-Version: 1.0
In-Reply-To: <BANLkTinHbCdYO-edOUA-iAPNzOfKgQNiRQ@mail.gmail.com>
References: <BANLkTinSOZH=9uD_9uXcVnH-1Yw5K-K3yg@mail.gmail.com>
 <20110425140035.GA27159@comet.dominikbrodowski.net> <BANLkTinaCZcxDEwn-z4u1CmQRm2h+Kkocw@mail.gmail.com>
 <20110425201417.GB1268@comet.dominikbrodowski.net> <BANLkTiks1LaJm_phZYi36z7aSix1fe7TdA@mail.gmail.com>
 <BANLkTikR+ZRwJRGEniW5McH6P+vp-80FvQ@mail.gmail.com> <BANLkTinHbCdYO-edOUA-iAPNzOfKgQNiRQ@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 27 Apr 2011 16:41:40 -0600
Message-ID: <BANLkTi=zkUJHZi4vvCbLCwUs2jgA-inm0Q@mail.gmail.com>
Subject: Re: PCIE-to-PCI bridge doesn't pass mem resources downstream [Re:
 yenta cardbus problem]
To: =?ISO-8859-1?Q?Germ=E1n_Sanchis?= <eaglecros@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 4:07 PM, Germán Sanchis <eaglecros@gmail.com> wrote:
> Hi!
> Well, that did work, so the sound card is being recognized now, and in fact
> I already managed to do a couple of successful sound tests.
> I am attaching the output of lspci -vvv after specifying pci=cbmemsize=8M,
> in case it helps you further... I am happy with my card working, but I don't
> know if this should be considered in future releases of the kernel.

Good, I'm glad the workaround works.

It sure seems like the kernel could be smarter about this.  After all,
we can (at least in principle) find out what devices are behind the
CardBus bridge and how much space they need.  Unfortunately, we don't
really have good support for dynamically rearranging things, so we
tend to request more space than we need in case the user later plugs
in another device.  It's a known problem and people are thinking about
it, but I'm afraid a complete solution is still a ways off.

Bjorn
