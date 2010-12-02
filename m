Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab0LBVPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:15:22 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61952 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab0LBVPV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:15:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=j1IWBD71ItApmDMNNEd8OIZHpY4CsLJY3qVres3sK4ExSr4XpdGhowpobCsKV2TaOl
         zNboKnZialJadxbI/PzPxaMr48PW6LpUokJQxp0AUml9dus2GNdyuEYa2BCqmMe19Cav
         B7HwfTm5E/Xx06ayllhLoEGM9LqfhpLlsMrhY=
MIME-Version: 1.0
In-Reply-To: <4CF7BA6D.60002@suse.cz>
References: <AANLkTin01j5oTUdh6fAgs--Gi46BZOWZCdypUPd8uhm4@mail.gmail.com>
	<4CF7BA6D.60002@suse.cz>
Date: Thu, 2 Dec 2010 16:15:20 -0500
Message-ID: <AANLkTinK9dKnSZdkH57dZNMysg0uVu7DfNtmmZdG8HZD@mail.gmail.com>
Subject: Re: [PATCH] Bug in scripts/package/mkspec?
From: Patrick LeBoutillier <patrick.leboutillier@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Sorry for the bad patch. Here is basically what I do:

$ make menuconfig
$ make rpm
...
Wrote: /root/rpmbuild/RPMS/x86_64/kernel-2.6.36.1-1.x86_64.rpm
...
$ make menuconfig # tweak some configs
$ make rpm
...
Wrote: /root/rpmbuild/RPMS/x86_64/kernel-2.6.36.1-1.x86_64.rpm
...


My expectation (and perhaps it is incorrect) is that subsequent "make
rpm"s on the same build tree
yield rpms with increasing release numbers (2.6.36.1-1, 2.6.36.1-2,
...). Is this how it's supposed
to work?

If that's the case, I think there needs to be a dependency between the
kernel.spec file and the .version file.
I think my (bad) patch worked once because it touched the mkspec
script, thereby causing the kernel.spec
file to be regenerated at the next "make rpm".


Patrick


On Thu, Dec 2, 2010 at 10:25 AM, Michal Marek <mmarek@suse.cz> wrote:
> On 18.11.2010 19:13, Patrick LeBoutillier wrote:
>> Hi all,
>>
>> I've been building RPMs for the Linux kernel for a while now and only
>> recently noticed that the RPM Release field is always set to 1.
>> After a bit of searching I found the offending line in
>> scripts/package/mkspec. Here is a patch that worked for me, but
>> perhaps this
>> could be fixed in better way by someone knowledgeable of the kernel
>> build process...:
>>
>>
>> --- ./mkspec.next       2010-11-18 13:08:56.000000000 -0500
>> +++ mkspec      2010-11-18 13:10:13.000000000 -0500
>> @@ -29,7 +29,7 @@
>>  echo "Version: $__KERNELRELEASE"
>>  # we need to determine the NEXT version number so that uname and
>>  # rpm -q will agree
>> -echo "Release: `. $srctree/scripts/mkversion`"
>> +echo "Release: `cd $srctree && ./scripts/mkversion`"
>
> This doesn't look correct to me, the script reads the .version file
> which is in the build directory, not in the source dir. Can you post a
> step-by-step reproducer for your bug?
>
> Thanks,
> Michal
>



-- 
=====================
Patrick LeBoutillier
Rosemère, Québec, Canada
