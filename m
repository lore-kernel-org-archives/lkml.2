Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab1AFT5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 14:57:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:44937 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab1AFT5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 14:57:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WvywAkEkwTuM6lNAf5SI2OiFQCbtjdpXS3YApDmurJaMt50cEgKXPVtYMzTu3diCDq
         sF9WdID6v9NJYakMx+2iDOsU3OIxWHGJOkN+zKbrCDYnHsxc2ey47N1DWDsHMhS8jzCX
         plv4UvIOEQDlOv3Z1saMOTGO9MVSdTDEr+6vI=
MIME-Version: 1.0
In-Reply-To: <4D26166D.1020009@zytor.com>
References: <20110106094423.GA17565@elte.hu>
	<AANLkTinU423YzQxB9y7ZM9GQAYPQyTJUm9w18=6P_F88@mail.gmail.com>
	<4D26166D.1020009@zytor.com>
Date: Thu, 6 Jan 2011 11:57:43 -0800
X-Google-Sender-Auth: 3PKlSlLYErV8Ew-zxPQ4t3dBh4Y
Message-ID: <AANLkTik7tcZo8ka80y=FD-_UxwvB6-R8iRHRq+rkOSo+@mail.gmail.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
From: Tony Luck <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 11:22 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>  I don't know if this is applicable on IA64.

I think that ia64 might need something like this too.  If I understand the
change correctly, it makes sure that we read all entries for cpus from the
SRAT table, so that we can figure out the topology for any cpus that we
decide to use (which may be at arbitrary positions in the SRAT table
as there is no guarantee that SRAT entries are in the same order as
MADT entries ... we might try to boot the first four cpus we find in
MADT, but those might be the last four entries in SRAT.)

It looks like this could be more simply achieved in an architecture
neutral way by just passing "0" as the last argument to
acpi_table_parse_srat() ... which will look at every entry
in SRAT (this is not exactly the same ... but it seems unlikely
that SRAT will have more than 32768 processor entries ... which
you are apparently willing to allow for with the MAX_LOCAL_APIC
value.)

-Tony
