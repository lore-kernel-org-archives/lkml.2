Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0EKSz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 14:55:57 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:33915 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab0EKSzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 14:55:39 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: April 27 (iscsi_ibft)
Date: Tue, 11 May 2010 13:58:48 -0400
User-Agent: KMail/1.9.10
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
       "Linux-Kernel" <linux-kernel@vger.kernel.org>,
       Peter Jones <pjones@redhat.com>, linux-next@vger.kernel.org
References: <80edf231-ef31-4f21-ab1b-1a21fda35809@default> <20100427230121.GA31743@andromeda.dapyr.net> <4BD85393.8020400@oracle.com>
In-Reply-To: <4BD85393.8020400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005111358.49290.konrad@darnok.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It is all b/c we now use the 'struct acpi_table_ibft *ibft_addr' which
> > is gone when !CONFIG_ACPI.
> >
> > Peter, if we did in an #ifdef !CONFIG_ACPI in iscsi_ibft.h and included
> > a copy of the old ibft_struct that should work.
> >
> > Or we make the code dependent on CONFIG_ACPI (in the Kconfig
> > file).
> >
> > Peter, Randy: Which option do you think makes more sense?
>
> I think that you and Peter know more about that than I do.
> I'd go for the Kconfig dependency.

Found a way that makes this go away. This is by including #include 
<linux/iscsi_ibft.h> in the module and it fixed the problem.
