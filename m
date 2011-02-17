Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab1BQW6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:58:19 -0500
Received: from mail.fuw.edu.pl ([193.0.80.14]:36362 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab1BQW6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:58:17 -0500
X-Greylist: delayed 2925 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Feb 2011 17:58:17 EST
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
To: Norbert Preining <preining@logic.at>
Subject: Re: regression 2.6.38-rc4 -> 2.6.38-rc5 suspend fails
Date: Thu, 17 Feb 2011 23:09:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc5+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
References: <20110217163300.GA7988@gamma.logic.tuwien.ac.at>
In-Reply-To: <20110217163300.GA7988@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102172309.26106.rwys@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 17, 2011, Norbert Preining wrote:
> Hi everyone,
> 
> (please Cc)
> 
> I have a regression here sinc e2.6.38-rc5 against -rc4, suspend does
> not work anymore.
> 
> Suspend in rc5 stops with "some devices cannot be suspend":
> [  186.824325] PM: Preparing system for mem sleep
> [  187.368534] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [  187.384141] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [  187.400154] PM: Entering mem sleep
> [  187.400217] Suspending console(s) (use no_console_suspend to debug)
> [  187.431788] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> [  187.431895] sd 0:0:0:0: [sda] Stopping disk
> [  187.480078] tpm_tis 00:0a: Operation Timed out
> [  187.480095] legacy_suspend(): pnp_bus_suspend+0x0/0x6a returns -62
> [  187.480101] PM: Device 00:0a failed to suspend: error -62
> [  187.919032] PM: Some devices failed to suspend
> [  187.919108] sd 0:0:0:0: [sda] Starting disk
> [  189.091224] PM: resume of devices complete after 1172.182 msecs
> [  189.091687] PM: Finishing wakeup.
> [  189.091691] Restarting tasks ... done.
> [  189.107075] video LNXVIDEO:00: Restoring backlight state
> 
> Interestingly I don't see anything in lspci with 00:0a

This is a PNP device.

What happens if you revert commit 9b29050 (tpm_tis: Use timeouts returned from TPM)?

Rafael

