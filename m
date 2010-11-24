Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0KXCUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 21:20:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab0KXCUH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 21:20:07 -0500
Date: Tue, 23 Nov 2010 21:19:38 -0500
From: Dave Jones <davej@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: x86@kernel.org, cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Missing "unregister_cpu_notifier" in powernow-k8.c
Message-ID: <20101124021938.GB1987@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Neil Brown <neilb@suse.de>,
	x86@kernel.org, cpufreq@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20101124112801.78830fba@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101124112801.78830fba@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 11:28:01AM +1100, Neil Brown wrote:
 > 
 > Hi,
 >  (hope I got the right addressees above....)
 > 
 >  I appears that when powernow-k8 find that 
 > 
 >     No compatible ACPI _PSS objects found.
 > 
 >  and suggests
 > 
 >     Try again with latest BIOS.
 > 
 >  it fails the module load, but does not unregister the cpu_notifier that was 
 >  registered in powernowk8_init
 > 
 >  This ends up leaving freed memory on the cpu notifier list for some other
 >  poor module (e.g. md/raid5) to come along and trip over.
 > 
 >  The following might be a partial fix, but I suspect there is probably other
 >  clean-up that is needed.
 > 
 >  ( https://bugzilla.novell.com/show_bug.cgi?id=655215 has full dmesg traces).
 
Ouch, I'm surprised that took so long to turn up.
I'll merge this up. It should go to stable too.

thanks,

	Dave

