Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0EKFz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 01:55:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:48703 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab0EKFzZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 01:55:25 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch]hp_accel: Fix race in device removal
Date: Tue, 11 May 2010 07:55:07 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc6-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Eric Piel <eric.piel@tremplin-utc.net>, Pavel Machek <pavel@ucw.cz>,
       Pavel Herrmann <morpheus.ibis@gmail.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
References: <201005071804.20462.oneukum@suse.de> <20100510154632.bbe181d8.akpm@linux-foundation.org>
In-Reply-To: <20100510154632.bbe181d8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005110755.07717.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 11. Mai 2010 00:46:32 schrieb Andrew Morton:
> But alas, I (and presumably others) cannot confirm that, because you
> didn't describe the bug :( This also means that if someone hits a
> problem with this driver, they won't easily be able to work out whether
> this patch will fix it.
> 
> 
> Under what circumstances does it trigger?
> 
> What are the observed effects when it triggers?
> 
> Please always include this sort of information when sending bugfixes, thanks.

Sorry,

the patch closes a window during which a work queue might remain
active after the device is removed and would then lead to ACPI calls
with undefined behavior.

	Regards
		Oliver
