Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1DWIVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 04:21:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44342 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1DWIVF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 04:21:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kvahKXbixEasZV8/uj09CgQgr61qf6BOFasgSfyWCYwjD7ao3GSS9Eg8kttiUQiGx3
         k6Ls9N6FmRxzBBJI7TchP8asBpEsM3DNaqhBdGqC8E2r3XSYovtJdClUe+D4dEvzDfDg
         vTZ6yY+R7zq2GPc57S4y5p4/FhWNZF/BA0wh4=
MIME-Version: 1.0
In-Reply-To: <20110421085124.4a44d048.randy.dunlap@oracle.com>
References: <20110421132045.5af1b953.sfr@canb.auug.org.au>
	<20110421085124.4a44d048.randy.dunlap@oracle.com>
Date: Sat, 23 Apr 2011 13:51:04 +0530
Message-ID: <BANLkTinoi1SeuuPj5SeTzssyBTvTQu6pMA@mail.gmail.com>
Subject: Re: linux-next: Tree for April 21 (i82975x_edac)
From: Arvind R <arvino55@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        bluesmoke-devel@lists.sourceforge.net, linux-edac@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 21, 2011 at 9:21 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Thu, 21 Apr 2011 13:20:45 +1000 Stephen Rothwell wrote:
>
>> Changes since 20110420:
>
>
> on i386:
>
> drivers/edac/i82975x_edac.c:298: warning: integer constant is too large for 'unsigned long' type
>
> which is:
>
>        if (info->xeap & 1)
>                page |= 0x100000000ul; <<<<<<<<<<<<<<<
>
> but page is unsigned long (32 bits), while 0x100000000ul is more than 32 bits,
> so that line isn't setting a bit in <page>.  Is it a bug, or this driver isn't
> applicable to X86_32, or what?
>
would defining page variable to unsigned long long solve it for x86_32?

That would still not fix the wrong error-info reported by the driver - this is
fixed by the patch-set titled '[RFC PATCH 2.6.37 0/4] i3000_edac : merge
i82975x support' dated 2011-02-14 in the linux-edac archives.

Please advise on getting the patch into main-stream. The I3000 is a re-labeled
i82975x (or vice-versa). Hence the patch-set to merge the drivers. If separate
i82975x driver is needed - I can provide the patch. The reported bug is not
present in the merge-patched driver.

Thanks,
Arvind.
