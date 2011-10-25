Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1JYIds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:33:48 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:40059 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1JYIdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:33:47 -0400
Message-ID: <1319531622.3056.1.camel@br98xy6r>
Subject: RE: kdump: crash_kexec()-smp_send_stop() race in panic
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 25 Oct 2011 10:33:42 +0200
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2C57612A37@USINDEVS01.corp.hds.com>
References: <1319468137.3615.16.camel@br98xy6r>
	 <m1ipneifqv.fsf@fess.ebiederm.org>
	 <CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
	 <m1aa8qfhdk.fsf@fess.ebiederm.org> <20111024173336.GB8044@redhat.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2C57612A37@USINDEVS01.corp.hds.com>
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Seiji,

On Mon, 2011-10-24 at 18:24 -0400, Seiji Aguchi wrote:
> Hi,
> 
> >> >>> 1st CPU:
> >> >>> panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump
> >> >>>
> >> >>> 2nd CPU:
> >> >>> panic()->crash_kexec()->kexec_mutex already held by 1st CPU
> >> >>>        ->smp_send_stop()-> stop CPU 1 (stop kdump)
> >> >>>
> >> >>> How should we fix this problem? One possibility could be to do
> >> >>> smp_send_stop() before we call crash_kexec().
> 
> http://lkml.org/lkml/2010/9/16/353
> 
> I developed a patch solving this issue one year ago.
> (Just adding local_irq_disable in kexec path.)

This won't work (at least on s390) because smp_send_stop() will also
stop CPUs that have interrupts disabled.

Michael

