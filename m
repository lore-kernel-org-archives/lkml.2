Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1HXCHk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 22:07:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58077 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738Ab1HXCHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 22:07:35 -0400
Subject: Re: linux-next: Tree for Aug 22 (evm)
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Mimi Zohar <zohar@us.ibm.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
In-Reply-To: <CACqU3MV-MfWxvVebcxiJK8BmxHG8epf=0bpsL7qoska65aVzSw@mail.gmail.com>
References: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
	 <20110822125355.bb01d76b.rdunlap@xenotime.net>
	 <CACqU3MVjg60pTPyNWm+41w144QzPgtHQ4wZPUUV=vok8gGffuQ@mail.gmail.com>
	 <20110822174958.73dd96c7.rdunlap@xenotime.net>
	 <1314065358.3225.44.camel@localhost.localdomain>
	 <CACqU3MV-MfWxvVebcxiJK8BmxHG8epf=0bpsL7qoska65aVzSw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 22:07:29 -0400
Message-ID: <1314151649.3247.43.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-08-22 at 22:24 -0400, Arnaud Lacombe wrote:
> Hi,
> 
> On Mon, Aug 22, 2011 at 10:09 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Mon, 2011-08-22 at 17:49 -0700, Randy Dunlap wrote:
> >> On Mon, 22 Aug 2011 20:47:00 -0400 Arnaud Lacombe wrote:
> >>
> >> > Hi,
> >> >
> >> > On Mon, Aug 22, 2011 at 3:53 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> >> > > On Mon, 22 Aug 2011 14:53:04 +1000 Stephen Rothwell wrote:
> >> > >
> >> > >> Hi all,
> >> > >>
> >> > >> [The kernel.org mirroring is a bit low today]
> >> > >
> >> > > (on x86_64:)
> >> > >
> >> > > When CONFIG_EVM=y, CONFIG_CRYPTO_HASH2=m, CONFIG_TRUSTED_KEYS=m,
> >> > > CONFIG_ENCRYPTED_KEYS=m, the build fails with:
> >> > >
> >> > You did not provide the value of CONFIG_TCG_TPM, I'll assume it was
> >> > 'm'. That said, correct me if I'm wrong, but we currently have:
> >>
> >> Yes, it was 'm'.
> >>
> >> > menuconfig TCG_TPM
> >> >         tristate "TPM Hardware Support"
> >> >
> >> > [...]
> >> >
> >> > config EVM
> >> >         boolean "EVM support"
> >> >         depends on SECURITY && KEYS && TCG_TPM
> >> >
> >> > which seems terribly broken to me... How can you have a built-in
> >> > feature, which depends on another potentially-not-built-in feature ?
> >>
> >> Yup.
> >
> > Easy, different use cases. The TPM has been around and used for a while,
> > not requiring it to be built-in.  EVM, a new use case, requires it to be
> > built-in.
> >
> What behavior is expected when TPM is built as a module ? Would you
> expect EVM to be accessible ?
> 
> >> > If you change EVM to 'tristate', you will see that you are not allowed
> >> > to make it built-in if TCG_TPM is not built-in.
> >>
> >> Right.
> >
> > The TPM, crypto, trusted and encrypted keys are tristate.  Like the
> > LSMs, EVM is boolean, which when selected using 'make xconfig', converts
> > the tristates to built-in.  The tristate/boolean mismatches aren't
> > corrected, when .config is edited directly.
> >
> well, ... no. 'xconfig' would seem to let you think they have been
> changed to 'y', but they have not. I have been able to generate a bad
> configuration (TPM module, EVM built-in) using only {menu,x}config.
> 
> btw, I never edit the configuration manually, there is a big fat "DO
> NOT EDIT" header in the beginning.
> 
> Depending on what you expect, one way to fix that is to make EVM
> depends on TCG_TPM = y, not just TCG_TPM.
> 
>  - Arnaud

Thanks, that seems to work for now.  I'd really like to remove the
trusted-key and TCG_TPM dependencies from encrypted keys.  Thus removing
the TCG_TPM dependency from EVM.  But then, trusted keys could be
enabled differently than encrypted keys.  

Is there a way of allowing 'A' not to be dependent on 'B', but if 'B' is
defined, force 'B' to be built-in if 'A' is built-in, or as a module if
'A' is a module?

thanks,

Mimi

