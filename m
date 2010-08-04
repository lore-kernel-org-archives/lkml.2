Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970Ab0HDUPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:15:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43456 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab0HDUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:15:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aXR9cZC4WIxpy1yKjGX7o5b2szMyobPRFVpTeb0kmZW7CodMgrSjRcfIfFPj9DPkae
         CWmL2eU9hoSYna73j5UypkeGFBjfqBCvbsnjDSX9454DiRdRE3X9wI0/NJq+0HimXl59
         tjkYgalZDuMzqPxC4jgnC91i4zJD102iY9Jq8=
Message-ID: <4C59CA4F.4090003@garzik.org>
Date: Wed, 04 Aug 2010 16:15:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Donald Parsons <dparsons@brightdsl.net>
CC: Harald Hoyer <harald.hoyer@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.35
References: <1280716262.5125.42.camel@falcon.homelinux.org> <201008012138.39036.bjorn.helgaas@hp.com> <1280722876.5125.83.camel@falcon.homelinux.org> <AANLkTimK8sv5aWfcv_BAmipgVnukR5NJsZQOXYbb2LAH@mail.gmail.com> <1280802701.5836.10.camel@falcon.homelinux.org>
In-Reply-To: <1280802701.5836.10.camel@falcon.homelinux.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 10:31 PM, Donald Parsons wrote:
> Using your suggestion as to where the problem lies, I investigated
> more deeply and found:
>
> I've now got 2.6.35-rc6-git3 to boot (and almost certainly 2.6.35 final)
>
> Make oldconfig broke at the transition where boot began failed, ie,
> between 2.6.34-git4 and 2.6.34-git5.   Even though modules are the
> same, boot fails.  If I use gconfig and set CONFIG_SATA_AHCI=y
> instead of CONFIG_SATA_AHCI=m it works, except cannot select =y
> unless CONFIG_ATA changed from m to y.
>
> So at some point in past, make oldconfig had apparently changed
> CONFIG_SATA_AHCI from y to m and system still booted.  But between
> 2.6.34-git4 and 2.6.34-git5 the ability to boot was lost.
>
> So make oldconfig is not 100% trustworthy in this case.  I do not
> know if this is a problem that should be fixed.  Ask if you want
> any .config diffs.


The modules are not necessarily the same:  "libahci" was introduced in

	commit 365cfa1ed5a36f9bcb9f64c9f0f52155af2e9fef
	Author: Anton Vorontsov <avorontsov@ru.mvista.com>
	Date:   Sun Mar 28 00:22:14 2010 -0400

	    ahci: Move generic code into libahci

so there exists the possibility that the initramfs builder, or whatever 
is being used to load your ATA drivers, missed this dependency.  Modern 
initramfs builders should be able to figure out module dependencies, so 
this /shouldn't/ be an issue...  but it might be.

	Jeff



