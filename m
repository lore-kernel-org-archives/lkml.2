Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759101Ab0FJNsx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 09:48:53 -0400
Received: from mtagate5.de.ibm.com ([195.212.17.165]:49631 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758198Ab0FJNsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 09:48:51 -0400
Date: Thu, 10 Jun 2010 15:48:48 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Sachin Sant <sachinp@in.ibm.com>, Avi Kivity <avi@redhat.com>,
       Carsten Otte <cotte@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: next June 10: S390 build failure [arch/s390/kvm/kvm.ko]
Message-ID: <20100610154848.616aff99@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <4C10DCB7.7090903@in.ibm.com>
References: <20100610160012.30ea7606.sfr@canb.auug.org.au>
	<4C10DCB7.7090903@in.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 18:08:15 +0530
Sachin Sant <sachinp@in.ibm.com> wrote:

> Today's next fails to build on a s390 box with
> 
> ERROR: "__kvm_s390_vcpu_store_status" [arch/s390/kvm/kvm.ko] undefined!
> 
> Yesterday's next was good.

That is caused by git commit fbc5eec58e652339e9df1332cd5e10e8d8250aaf
which fails to take git commit 5288fbf0ef041ba0e8b4dcb2df4536b5e3a48b32
into account. There is a second caller of __kvm_s390_vcpu_store_status
in arch/s390/kvm/intercept.c. As far as I understand the code you could
just drop the 'static' from kvm_s390_vcpu_store_status and call it from
handle_stop instead of the old __kvm_s390_vcpu_store_status.

Carsten, Christian: could one of you have a look please?

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

