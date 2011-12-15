Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1LOJir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:38:47 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53251 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab1LOJip convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:38:45 -0500
Message-ID: <1323941914.16998.3.camel@hornet.cambridge.arm.com>
Subject: Re: [PATCH 1/2] params: <level>_initcall-like kernel parameters
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Thu, 15 Dec 2011 09:38:34 +0000
In-Reply-To: <871us6sdaz.fsf@rustcorp.com.au>
References: <1323712401.2391.93.camel@hornet.cambridge.arm.com>
	 <1323712627-17353-1-git-send-email-pawel.moll@arm.com>
	 <871us6sdaz.fsf@rustcorp.com.au>
X-Mailer: Evolution 3.2.1-
Mime-Version: 1.0
X-OriginalArrivalTime: 15 Dec 2011 09:38:34.0475 (UTC) FILETIME=[506643B0:01CCBB0D]
X-MC-Unique: 111121509383701601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Morning,

On Thu, 2011-12-15 at 03:51 +0000, Rusty Russell wrote:
> On Mon, 12 Dec 2011 17:57:06 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> > This patch adds a set of macros that can be used to declare
> > kernel parameters to be parsed _before_ initcalls at a chosen
> > level are executed. Such parameters are marked using existing
> > "flags" field of the "kernel_param" structure.
> > 
> > Linker macro collating init calls had to be modified in order
> > to add additional symbols between levels that are later used
> > by the init code to split the calls into blocks.
> 
> This patch wasn't quite what I was thinking, but I've realized that
> we can't put the params in the .init section, your approach is probably
> the best one.

The only way I could think of to put the parameters passing code in
between levels was adding new linker sections, and that sounded like an
overkill...

> Note that I've just created a series which gets rid of that silly ISBOOL
> thing, so you can use the whole field for "level".  Then I set the level
> to -1 for the normal calls; I want to use -2 for the early calls, but
> that's not done yet...
> 
> I'll rework and rebase your patch like that now.

Cool, it's all yours, especially now that I'm the last day at work this
year so won't be able to contribute much in the following weeks... Could
I just ask you to remember about the virtio_mmio parameters patch if you
get somewhere with this? I'll be most grateful!

Cheers!

Paweł


