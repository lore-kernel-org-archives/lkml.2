Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab0D0XBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 19:01:52 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:53936 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab0D0XBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 19:01:51 -0400
Date: Tue, 27 Apr 2010 19:01:21 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Peter Jones <pjones@redhat.com>,
       Konrad Rzeszutek Wilk <konrad@kernel.org>, linux-next@vger.kernel.org
Subject: Re: linux-next: April 27 (iscsi_ibft)
Message-ID: <20100427230121.GA31743@andromeda.dapyr.net>
References: <80edf231-ef31-4f21-ab1b-1a21fda35809@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80edf231-ef31-4f21-ab1b-1a21fda35809@default>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 09:13:16AM -0700, Randy Dunlap wrote:
> when CONFIG_ACPI is not enabled:
> 
> drivers/firmware/iscsi_ibft_find.c:112: error: dereferencing pointer to incomplete type
> drivers/firmware/iscsi_ibft_find.c:112: error: dereferencing pointer to incomplete type
> drivers/firmware/iscsi_ibft_find.c:112: warning: type defaults to 'int' in declaration of 'type name'
> drivers/firmware/iscsi_ibft_find.c:112: error: dereferencing pointer to incomplete type
> drivers/firmware/iscsi_ibft_find.c:112: warning: type defaults to 'int' in declaration of 'type name'

Yikes.

Randy, thank you for spotting this and sending an e-mail my way.

It is all b/c we now use the 'struct acpi_table_ibft *ibft_addr' which
is gone when !CONFIG_ACPI.

Peter, if we did in an #ifdef !CONFIG_ACPI in iscsi_ibft.h and included
a copy of the old ibft_struct that should work.

Or we make the code dependent on CONFIG_ACPI (in the Kconfig
file).

Peter, Randy: Which option do you think makes more sense?
