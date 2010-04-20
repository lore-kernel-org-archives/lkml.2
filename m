Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab0DTPAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 11:00:19 -0400
Received: from adelie.canonical.com ([91.189.90.139]:52383 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab0DTPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 11:00:15 -0400
Date: Tue, 20 Apr 2010 09:00:10 -0600
From: Alex Chiang <achiang@canonical.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH] acpi: Fall back to manually changing SCI_EN
Message-ID: <20100420150010.GA17935@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org, lenb@kernel.org
References: <1271711614-15527-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271711614-15527-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Garrett <mjg@redhat.com>:
> The ACPI spec tells us that the ACPI SCI_EN bit is under hardware control
> and shouldn't be touched by the OS. It seems that the Leading Other OS
> ignores this and some machines expect this behaviour. We have a blacklist
> for these, but given that we're able to detect the failure case and the
> alternative to breaking the spec is letting the machine crash and burn,
> let's try falling back when we know the alternative is a mostly-dead
> machine.

Yes, we got a hint from a Lenovo BIOS developer:

	A SCI_EN bit had not been set at S3 resume post. It
	should be set as ACPI defines. It seems that Windows OS
	sets SCI_EN bit by itself after S3 resume....

So I believe that Matthew's approach is reasonably safe and
correct.

Acked-by: Alex Chiang <achiang@canonical.com>

/ac
