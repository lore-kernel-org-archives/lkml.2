Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab2IYTWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:22:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:55132 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2IYTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:22:18 -0400
Date: Tue, 25 Sep 2012 20:22:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] PNP: Unbind drivers if the new driver matches _HID
 rather than _CID
Message-ID: <20120925192211.GA24750@srcf.ucam.org>
References: <1348579544-1573-1-git-send-email-mjg@redhat.com>
 <1348579544-1573-2-git-send-email-mjg@redhat.com>
 <CAErSpo7giiZEnXkRY+QnhAV_2EGwdnju7S1-futjnKBjr7sY-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo7giiZEnXkRY+QnhAV_2EGwdnju7S1-futjnKBjr7sY-A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:04:25PM -0600, Bjorn Helgaas wrote:
> On Tue, Sep 25, 2012 at 7:25 AM, Matthew Garrett <mjg@redhat.com> wrote:

> Do you know of any scenarios besides this IPMI one where there's the
> possibility of two drivers matching the same device?  If so, does the
> detach/attach process work reasonably?  My worry is that drivers don't
> normally give up devices, so the detach path is not well exercised.
> And I don't know what happens to any users of the device during the
> switch.  For example, if something was using a TPM and we replaced the
> driver, what does that look like to the user?

Yeah, this could definitely happen with TPM - tpm_infinion could 
displace tpm_tis. This actually flags up something kind of obviously 
broken in the TPM code, since tpm_infineon comes *after* tpm_tis in the 
link order despite being more specific. Winning. It looks like there's a 
valid tpm_release function, but I'll find an infineon machine and figure 
out whether it actually works or not.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
