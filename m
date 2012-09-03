Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2ICBju (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 21:39:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53226 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab2ICBjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 21:39:49 -0400
Message-ID: <50440A5A.900@canonical.com>
Date: Mon, 03 Sep 2012 09:39:38 +0800
From: Jeremy Kerr <jeremy.kerr@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [RFC,PATCH] efi: Add support for a UEFI variable filesystem
References: <1346319009.951368.767015086462.1.gpush@pecola> <503FA15F.7070506@zytor.com> <50400859.2080606@canonical.com> <5e40036f-b0da-47f3-acba-5dea9fdb7ed6@email.android.com>
In-Reply-To: <5e40036f-b0da-47f3-acba-5dea9fdb7ed6@email.android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi hpa,

> Wouldn't that be better handled by O_APPEND?

Possibly, but this then means that there are now two "interfaces" that
specify the variable attributes.

[Also, in that case we should support the same mechanism through open();
llseek(0, SEEK_END) then, right?]

In general, I think the attributes-in-a-header mechanism is a little
tidier than providing them in the filename. For instance, finding if a
variable exists from userspace will require iterating the dentries (or
trying all combinations of variables), if the attributes aren't known.

However, I'm happy to implement this if it's the generally-preferred
solution.

Cheers,


Jeremy


