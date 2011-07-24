Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1GXOwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 10:52:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58447 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1GXOwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 10:52:31 -0400
MIME-Version: 1.0
In-Reply-To: <F87D23B7E1F84E4AB52E4FA4A55F85DC026DADA5@tpamail.elutions.com>
References: <CACTFLANAFT=G4kFvHUqvLrt=MxgpJnJ-EeHY8zd49pZvsNRejw@mail.gmail.com>
	<F87D23B7E1F84E4AB52E4FA4A55F85DC026DADA5@tpamail.elutions.com>
Date: Sun, 24 Jul 2011 16:52:30 +0200
Message-ID: <CACTFLANxErq=-9tZBJDOrF6J7SXf3zRttnOA6cCkoQmVoBLV0w@mail.gmail.com>
Subject: Re: Regression in handling of unsafe UBI shutdown
From: Daniel Mack <zonque@gmail.com>
To: Mike Hench <mhench@elutions.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Sven Neumann <s.neumann@raumfeld.com>,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 1:45 PM, Mike Hench <mhench@elutions.com> wrote:
>> UBIFS: recovery needed
>> Error reading superblock on volume 'ubi:RootFS'!
>> UBIFS not mounted, use ubifs mount to mount volume first!
>> Wrong Image Format for bootm command
>> ERROR: can't get kernel image!
>
>
> Be nice to know what error.
> FWIW:
> a) I do not see this. I have very limited experience with 3.0-rc7 though
> so maybe I should not say anything :-)
>
> b) sometimes UBIFS decides to do recovery in u-boot, sometimes not.
> it seems to depend on the type of content in the journal.
> Lots of deleted files seem to trigger u-boot to perform a recovery for
> instance.
> I was running out of memory In u-boot while replaying the journal
> at one point with an older kernel. This produced the same top level
> error.

Thank you very much vor mentioning this, as it totally pointed me in
the right direction. Whatever really caused it, we ended up with
larger journal produced by newer kernels in comparison to older ones,
and U-Boot indeed ran out memory when trying to access the FS later.
Increasing the amount of available memory in U-Boot fixes the problem
for us.

Sorry for scaring you, but it looked like a major regression in the
first place. And thanks again to everyone for helping sort this out.


Daniel
