Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300Ab1FXOgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 10:36:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:32901 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab1FXOf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 10:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:cc
         :content-type:content-transfer-encoding;
        b=Za8xjQKXty3LYQ4vEvKxNZXY2qXt8C7SZzvMdd88GCncSZX1IopjZtyC/4XFWWBVXd
         k7PWO3R1aLE9zSn/G37Q==
MIME-Version: 1.0
In-Reply-To: <20110624080535.GA19966@phantom.vanrein.org>
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de>
	<20110623133950.GB28333@srcf.ucam.org>
	<4E0348E0.7050808@kpanic.de>
	<20110623141222.GA30003@srcf.ucam.org>
	<4E035DD1.1030603@kpanic.de>
	<20110623170014.GN3263@one.firstfloor.org>
	<987664A83D2D224EAE907B061CE93D5301E938F2FD@orsmsx505.amr.corp.intel.com>
	<BANLkTikTTCU3eKkCtrbLbtpLJtksehyEMg@mail.gmail.com>
	<20110624080535.GA19966@phantom.vanrein.org>
Date: Fri, 24 Jun 2011 07:35:55 -0700
Message-ID: <BANLkTim2yoYFTG4MZxv7KH1ujTV2h5c+LHb8hCp2dHCqZvbKYA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
From: Craig Bergstrom <craigb@google.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 1:05 AM, Rick van Rein <rick@vanrein.org> wrote:
>
> Hi Craig,
>
> > We (Google) are working on a data-driven answer for this question.  I know
> > that there has been some analysis on this topic on the past, but I don't
> > want to speculate until we've had some time to put all the pieces together.
>
> The easiest way to do this could be to take the algorithm from Memtest86
> and apply it to your data, to see if it finds suitable patterns for the
> cases tried.
>
> By counting bits set to zero in the masks, you could then determine how
> 'tight' they are.  A mask with all-ones covers one memory page; each
> zero bit in the mask (outside of the CPU's page size) doubles the number
> of pages covered.
>
> You can ignore the address over which the mask is applied, although you
> would then be assuming that all the pages covered by the mask are indeed
> filled with RAM.
>
> You would want to add the figures for the different masks.

This seems like a reasonable approach.  I know there was some analysis
done, and I'm doing my best to get the folks who made the original
decision to weigh in.

>
> I am very curious about your findings.  Independently of those, I am in
> favour of a patch that enables longer e820 tables if it has no further
> impact on speed or space.

I think that we'd all be satisfied with a mechanism that allows for
badram to be specified via both command line and an extended e820 map.

>
>
> Cheers,
>  -Rick
