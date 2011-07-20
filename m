Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317Ab1GTMuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 08:50:51 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45047 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1GTMuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 08:50:50 -0400
MIME-Version: 1.0
In-Reply-To: <1311165141.20738.171.camel@sauron>
References: <CACTFLANAFT=G4kFvHUqvLrt=MxgpJnJ-EeHY8zd49pZvsNRejw@mail.gmail.com>
	<1311139283.20738.150.camel@sauron>
	<CACTFLANrd0FO9GNJpvS+MxnQgLLtXpA-sai30oYN90cjEFOErA@mail.gmail.com>
	<1311165141.20738.171.camel@sauron>
Date: Wed, 20 Jul 2011 14:50:48 +0200
Message-ID: <CACTFLAPidcRtg9qH8FwdVZWUQeyBVgKgVGgc=NNzdGhU6OAr=A@mail.gmail.com>
Subject: Re: Regression in handling of unsafe UBI shutdown
From: Daniel Mack <zonque@gmail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sven Neumann <s.neumann@raumfeld.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 2:32 PM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Wed, 2011-07-20 at 11:18 +0200, Daniel Mack wrote:

>> So, let me re-phrase my question: is anyone aware of changes in the
>> UBIFS code between 2.6.36 and 3.0 that might cause trouble to U-Boot's
>> UBI code from 2009?
>
> I guess that would be an on-flash format change? I am not aware of such
> changes, and if there were such - this is a big issue which we wound
> need to fix.

Yes. And more tests show that we appearantly also have a more severe
problem here. Some devices that have been power-cut during operation
even refuse to create a new UBI from Linux on the NAND after they're
toast (we use this procedure as a debricking option for customers).
The only thing that helps in such cases is erasing the NAND from
U-Boot. After that, the UBI creation works again. Any more ideas on
how to debug this would be appreciated.


Daniel
