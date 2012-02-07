Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040Ab2BGWah (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:30:37 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55696 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab2BGWaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:30:35 -0500
Message-ID: <1328653791.18150.5.camel@js-netbook>
Subject: Re: [PATCH 1/8] PM / Sleep: Initialize wakeup source locks in
 wakeup_source_add()
From: John Stultz <john.stultz@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <greg@linuxfoundation.org>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 07 Feb 2012 14:29:51 -0800
In-Reply-To: <201202070201.58025.rjw@sisk.pl>
References: <201202070200.55505.rjw@sisk.pl>
	 <201202070201.58025.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020722-4242-0000-0000-000000B54B9B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-07 at 02:01 +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Initialize wakeup source locks in wakeup_source_add() instead of
> wakeup_source_create(), because otherwise the locks of the wakeup
> sources that haven't been allocated with wakeup_source_create()
> aren't initialized and handled properly.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ah, I've shot myself in the foot before, forgetting to init the wakeup
source, so this should be good. Although, would a WARN_ON be better then
just initializing the lock in add? That way bad behavior is more likely
to be corrected, rather then just ignored.

thanks
-john

