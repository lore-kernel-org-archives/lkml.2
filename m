Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab0HRAqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 20:46:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:44477 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab0HRAqI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 20:46:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=kVyI0KSqVNIBZsTB2qFOe0tKE8CN4bkEqtUXKqSgjrloqnsebG3Zlm+9YrvbBsYhK
	aMDdQuPWQbMVIcGuk0BHg==
MIME-Version: 1.0
In-Reply-To: <20100818104057.5fdaf20d.sfr@canb.auug.org.au>
References: <20100818104057.5fdaf20d.sfr@canb.auug.org.au>
Date: Tue, 17 Aug 2010 17:46:05 -0700
Message-ID: <AANLkTinJ8ks85Ym11wd4csdqFVgQpS7nw=RrfhMrLPUH@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the libata tree
From: Gwendal Grignou <gwendal@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jeff Garzik <jeff@garzik.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Grundler <grundler@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let me fix it and send a patch to Jeff.

Gwendal.

On Tue, Aug 17, 2010 at 5:40 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Jeff,
>
> After merging the libata tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> drivers/ata/libata-transport.c: In function 'ata_attach_transport':
> drivers/ata/libata-transport.c:678: error: implicit declaration of function 'kzalloc'
> drivers/ata/libata-transport.c:678: warning: assignment makes pointer from integer without a cast
> drivers/ata/libata-transport.c: In function 'ata_release_transport':
> drivers/ata/libata-transport.c:741: error: implicit declaration of function 'kfree'
>
> Caused by commit 97395d39931160a171959ac2e1fbff1caba3374b ("[libata] Add
> ATA transport class") neglecting to include linux/slab.h.   See Rule 1 in
> Documentation/SubmitChecklist.
>
> I have used the libata tree form next-20100817 for today.
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/
>
