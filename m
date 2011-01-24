Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1AXBNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 20:13:34 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49043 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab1AXBNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 20:13:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CZdi8IflktuEE/l4SiKKvakoqoiN8sXu36ksX1ApTYTP2IPtGalbA1M1Ws79zP8mZq
         sihD3pRY72fsZWDPiF30Pf9Eh1tiYOOcwTAq5rJFMj7cNh1OoJZfXKtbLb60BHl6Qjoq
         3Qv5hVfY8GY7wlHY9WgDmAdtG610vsU5mYGuk=
MIME-Version: 1.0
In-Reply-To: <201101232128.03007.rjw@sisk.pl>
References: <201101201226.41021.rjw@sisk.pl>
	<201101222012.14028.rjw@sisk.pl>
	<AANLkTikstr=vY=1S7A4Pudg3u=k4eJ7HRz6tWwAq4N-v@mail.gmail.com>
	<201101232128.03007.rjw@sisk.pl>
Date: Mon, 24 Jan 2011 09:13:30 +0800
Message-ID: <AANLkTi=YwD7kBZ6XsnUpCfqCmTuwwhkcAYvjXJL3Fj8O@mail.gmail.com>
Subject: Re: [PATCH 0/11] ACPI: Fixes and cleanups related to iomaps management
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 4:28 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, January 23, 2011, Jeff Chua wrote:
>> On Sun, Jan 23, 2011 at 3:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Saturday, January 22, 2011, Jeff Chua wrote:
>> >> 2011/1/22 Rafael J. Wysocki <rjw@sisk.pl>:
>> >> > On Saturday, January 22, 2011, Jeff Chua wrote:
>> Strange. If I didn't offline, it hanged during suspend even without
>> thinkpad_acpi. I could see that the suspend code does the offline
>> automatically, but executing the offline before calling suspend makes
>> it no hanging.
>
> That means there's a problem in the CPU hotplug code that manifests itslef
> during suspend.  Is this 100% reproducible?  Did it happen with 2.6.37?

Quite reproducible. Once "something" trigger the hang,  no matter how
I reset the system, it'll still hang at suspend. And at other times,
it just worked. I tried many things, but it seems if I go back to use
an earlier version (2.6.37 works perfectly for suspend-to-disk/mem),
then switched back to the newer broken version, it'll work for a few
cycles before hanging at suspend-to-disk.

I guess it could be CPU hotplug, and may be that thinkpad-acpi is
triggering the broken cpu hotplug to fail.

Jeff
