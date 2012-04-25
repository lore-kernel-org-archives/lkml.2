Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2DYJl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 05:41:57 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4699 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881Ab2DYJl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 05:41:56 -0400
Message-ID: <1335346910.1611.9.camel@t41.thuisdomein>
Subject: Re: [PATCH] TPM: chip disabled state erronously being reported as
 error
From: Paul Bolle <pebolle@tiscali.nl>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Date: Wed, 25 Apr 2012 11:41:50 +0200
In-Reply-To: <20120424205717.GA3755@localhost>
References: <20120424205717.GA3755@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.0.1 (3.4.0.1-1.fc18) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 25 Apr 2012 09:41:50.0424 (UTC) FILETIME=[A3B8B580:01CD22C7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rajiv,

On Tue, 2012-04-24 at 17:57 -0300, Rajiv Andrade wrote:
> Can you test it?

Sure. Your patch applied cleanly to the current Fedora 16 kernel's
sources (ie, kernel-3.3.2-6.fc16). One boot and one suspend-and-resume
cycle both were without the error message that bothered me so much.

That should be all testing that this patch needs, shouldn't it?

> tpm_do_selftest() attempts to read a PCR in order to
> decide if one can rely on the TPM being used or not.
> The function that's used by __tpm_pcr_read() does not
> expect the TPM to be disabled or deactivated, and if so,
> reports an error.
> 
> It's fine if the TPM returns this error when trying to
> use it for the first time after a power cycle, but it's
> definitely not if it already returned success for a
> previous attempt to read one of its PCRs.
> 
> The tpm_do_selftest() was modified so that the driver only
> reports this return code as an error when it really is.
> 
> Reported-by: Paul Bolle <pebolle@tiscali.nl>

I guess that is now "Reported-and-tested-by", even though the test was
run against a v3.3.2 based kernel.

> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

Should this be CC-ed to stable for v3.3?


Paul Bolle

