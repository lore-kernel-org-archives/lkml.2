Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0JSPsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:48:13 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45133 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0JSPsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:48:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Zb5oSQE2rPniSDHiMd0M21vUouCLhpq4u/lgV9msgvbMoqycQ4qrYyE+RSma1y9sk1
         Gqi1YftIPwxfvr9FBeOEExKy+Wo0yf1NyIhsrJk24AD2y3FB9Sc0saDF0/SDX/fN0hOw
         K9pi8wu/+sB5DPYZBPV6znb2fltXlzATif4YI=
MIME-Version: 1.0
In-Reply-To: <20101019091339.38e45faa@tlielax.poochiereds.net>
References: <20100924135531.96e5ac72.sfr@canb.auug.org.au>
	<20101019162120.76e03b4b.sfr@canb.auug.org.au>
	<20101019091339.38e45faa@tlielax.poochiereds.net>
Date: Tue, 19 Oct 2010 10:48:10 -0500
Message-ID: <AANLkTi=kc_8gqDnMVc4Sjm4=XvuUB+-Y5Tz_8sgfkw7P@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the cifs tree
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: Jeff Layton <jlayton@samba.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Steve French <smfrench@gmail.com>,
        linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 8:13 AM, Jeff Layton <jlayton@samba.org> wrote:
> On Tue, 19 Oct 2010 16:21:20 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
>> Hi Steve,
>>
>> On Fri, 24 Sep 2010 13:55:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> >
>> > After merging the irqflags tree, today's linux-next build (powerpc
>> > ppc64_defconfig) produced this warning:
>> >
>> > fs/cifs/sess.c: In function 'CIFS_SessSetup':
>> > fs/cifs/sess.c:595: warning: unused variable 'blob_len'
>> >
>> > Introduced by commit 15f6bdfb9914b0c41848f874719911ba053be931 ("cifs
>> > NTLMv2/NTLMSSP ntlmv2 within ntlmssp autentication code").
>> > CONFIG_CIFS_UPCALL is not set in this build.
>>
>> I am still getting this ...
>>
>
> Yep. Looks clearly broken. blob_len is also declared twice in that
> function which is just plain wrong. What probably makes the most sense
> is to make it a u16 and get rid of the second declaration lower in the
> function. But, there's another semi-related problem here too...
>
> blob_len gets assigned the return value of build_ntlmssp_auth_blob.
> That function however doesn't have any mechanism to pass back an
> error, even though it calls setup_ntlmv2_rsp and that function can
> return one.
>
> The whole house of cards needs a bit of rework I think...
>
> Shirish, since you're already doing work in this area, can you fix that
> too?
>
> Thanks,
> --
> Jeff Layton <jlayton@samba.org>
>

Looking into it.
