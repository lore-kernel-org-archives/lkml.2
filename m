Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab2IXJR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:17:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41389 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2IXJRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:17:23 -0400
Date: Mon, 24 Sep 2012 10:21:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Thomas Renninger <trenn@suse.de>
Cc: Len Brown <lenb@kernel.org>, hpa@zytor.com, initramfs@vger.kernel.org,
        robert.moore@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, yinghai@kernel.org,
        eric.piel@tremplin-utc.net, vojcek@tlen.pl
Subject: Re: [PATCH 2/2] ACPI: Override arbitrary ACPI tables via initrd for
 debugging
Message-ID: <20120924102159.346d0735@pyramind.ukuu.org.uk>
In-Reply-To: <201209240840.29342.trenn@suse.de>
References: <1348234085-39220-1-git-send-email-trenn@suse.de>
	<201209230317.04050.trenn@suse.de>
	<505E8F44.9020208@kernel.org>
	<201209240840.29342.trenn@suse.de>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The issue is/was, that root can inject code at runtime which is then
> executed in kernel environment.

Yes there are lots of other ways to do this too. The constraint we use
for it is CAP_SYS_RAWIO. With that capability you can totally do raw
hardware access and the like so requiring it for runtime ACPI updating
and execution is consistent with the security model.

> Afaik there are "security" provisions or say setups, which do
> hide modprobe/insmod and do not allow root to load any kernel drivers 
> or similar.

To do this you have to revoke CAP_SYS_RAWIO.

Alan
