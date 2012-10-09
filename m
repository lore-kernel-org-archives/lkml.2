Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab2JIKzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 06:55:36 -0400
Received: from mga06.intel.com ([134.134.136.21]:13442 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750967Ab2JIKzc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 06:55:32 -0400
MIME-Version: 1.0
In-Reply-To: <87ehlf2l9w.fsf@rustcorp.com.au>
References: <874nmd4d2o.fsf@rustcorp.com.au>
	<87wqzdnwus.fsf@rustcorp.com.au>
	<87ipay3cof.fsf@rustcorp.com.au>
	<87bogs492s.fsf@rustcorp.com.au>
	<87ehlp30pd.fsf@rustcorp.com.au>
	<5555.1348531649@warthog.procyon.org.uk>
	<8168.1348650575@warthog.procyon.org.uk>
	<16088.1348736905@warthog.procyon.org.uk>
	<27378.1348819793@warthog.procyon.org.uk>
	<29451.1348903010@warthog.procyon.org.uk>
	<23688.1349186865@warthog.procyon.org.uk>
	<87ehlf2l9w.fsf@rustcorp.com.au>
Date: Tue, 9 Oct 2012 13:55:30 +0300
Message-ID: <CALLzPKZaayux=ocJucr=rrzcDx0DxRxv0xLpkt4ZPVU7pbw0kg@mail.gmail.com>
Subject: Re: [GIT PULL] Asymmetric keys and module signing
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, herbert@gondor.hengli.com.au,
        pjones@redhat.com, jwboyer@redhat.com, linux-crypto@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 2:22 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> David Howells <dhowells@redhat.com> writes:
>
>> Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>>> Right.  I think we need to use different names for generated vs supplied
>>> files
>>
>> The problem with supplied files is people who do allyesconfig, allmodconfig
>> and randconfig just to test things finding that their builds break.  The
>> kernel build magic is not really set up to handle external files like this.  I
>> suppose make logic can be used to conditionally include stuff that might not
>> exist.
>>
>>> BTW, you missed a Signed-off-by: on your "MODSIGN: Use the same digest
>>> for the autogen key sig as for the module sig" patch.  Please update.
>>
>> Done.
>>
>> I've also added a patch to convert the system clock to a struct tm and to
>> produce a struct tm within the ASN.1 decode and then compare those rather than
>> time_t values as a way to deal with the validity time overflow problem.  We
>> may have to be able to handle certificates that we haven't generated that
>> stretch beyond 2038 (I wonder if we might find such in the UEFI key database
>> for example.
>
> OK, cherry-picked to replace my hack.
>
> It's in linux-next, and I will push in the next two days.
>


http://git.kernel.org/?p=linux/kernel/git/rusty/linux.git;a=commit;h=a15e196c5543d1d2d7f0cd70e62351aeb1f8b871

It breaks bisect..

  CC      kernel/module_signing.o
kernel/module_signing.c: In function ‘mod_verify_sig’:
kernel/module_signing.c:21:10: error: ‘ENOKEY’ undeclared (first use
in this function)
kernel/module_signing.c:21:10: note: each undeclared identifier is
reported only once for each function it appears in
kernel/module_signing.c:22:1: warning: control reaches end of non-void
function [-Wreturn-type]
make[1]: *** [kernel/module_signing.o] Error 1
make: *** [kernel] Error 2
make: *** Waiting for unfinished jobs....

> Thanks,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
