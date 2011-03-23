Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1CWGGD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 02:06:03 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40469 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab1CWGGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 02:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=CbHuo2g1G/8PiGj4bo/Bcv/pItEHqbjtMzvNs5NGPJHxdxiFuIFArktZAthSOyoCst
         lP/ldqkXMcW28h2JjOMELdXw6J2cgP7MucWTueXmSI3vGVabnCGm+bNYzxAE/sjh+HGD
         Irrq5yGjJ7Jd2js9bBFZuPXgNbbgbGf011a/I=
MIME-Version: 1.0
In-Reply-To: <20110322133409.GN14675@home.goodmis.org>
References: <AANLkTimjmdi8sFTTjSPerOVgHQ+pjjwwMvCUX3AJ16At@mail.gmail.com>
	<AANLkTimxrdhhukoVP76c4PUzeWsKOEy-_bHOgCCFabxc@mail.gmail.com>
	<20110322133409.GN14675@home.goodmis.org>
Date: Wed, 23 Mar 2011 07:05:58 +0100
Message-ID: <AANLkTinE-bhSAuLHQQzHOoktGpf2bDMLUB04uo7EO7qv@mail.gmail.com>
Subject: Re: [bisect] kernel 2.6.38 regression with root nfs mounting
From: Belisko Marek <marek.belisko@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Brian Downing <bdowning@lavos.net>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 2:34 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, Mar 22, 2011 at 08:52:12AM +0100, Belisko Marek wrote:
>> CC: also lkml
>
> And please Cc those that are on that commit.
>
>
>>
>> After update from 2.6.38-rc8 to 2.6.38 is mounting rootfs over nfs not possible.
>> Log:
>> VFS: Mounted root (nfs filesystem) on device 0:14.
>> Freeing init memory: 132K
>> nfs: server 10.146.1.21 not responding, still trying
>> nfs: server 10.146.1.21 not responding, still trying
>>
>> This is never ending. I make short bisect (not too much commits
>> between versions)
>> and bad commit was reported: 53d4737580535e073963b91ce87d4216e434fab5
>>
>> NFS: NFSROOT should default to "proto=udp"
>>
>> I've tested on mini2440 board (DM9000, static IP).
>> Is there some missing option or something else to be checked?
>
> Sometimes git bisect messes up. Did you verify that commit broke the
> kernel? It's easy to do:
Sure I did same thing to check if bisect is correct. I try to check also patch
but after short look it doesn't seems to be something strange or guilty there.
>
> git checkout 53d4737580535e073963b91ce87d4216e434fab5~1
>
> then build and boot the kernel and test if it works.
>
> git checkout 53d4737580535e073963b91ce87d4216e434fab5
>
> then build and boot again and test if it fails.
>
> If the first checkout works and the second fails, then you have verified
> that is the guilty commit.
>
> Thanks,
>
> -- Steve
>
>>
>> Regards,
>>
>> marek
>>
>> --
>> as simple and primitive as possible
>> -------------------------------------------------
>> Marek Belisko - OPEN-NANDRA
>> Freelance Developer
>>
>> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
>> Tel: +421 915 052 184
>> skype: marekwhite
>> icq: 290551086
>> web: http://open-nandra.com
>

regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
