Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab1ICMgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 08:36:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39269 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab1ICMgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 08:36:17 -0400
Date: Sat, 3 Sep 2011 13:36:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] pstore: update the policy of the UEFI-based backend
Message-ID: <20110903123611.GA28765@srcf.ucam.org>
References: <1315027817-5316-1-git-send-email-gong.chen@linux.intel.com>
 <1315027817-5316-3-git-send-email-gong.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315027817-5316-3-git-send-email-gong.chen@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't think this is reasonable. EFI variable space is a shared 
resource. We have no idea what the failure modes of entirely filling it 
would be. If we're going to store multiple records then at the very 
least we need to use QueryVariableInfo() to identify how much space 
there is left, and if it's a 2.1 or later system then we ideally need to 
store these as EFI_VARIABLE_HARDWARE_ERROR_RECORD rather than just plain 
runtime variables. The reason the current implementation doesn't do that 
is that there's still hardware floating around that implements EFI 1.10 
rather than UEFI 2.0

-- 
Matthew Garrett | mjg59@srcf.ucam.org
