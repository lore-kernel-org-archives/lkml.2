Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab1BGSoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 13:44:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56116 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab1BGSoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 13:44:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qMyvru4ufi1obJq6F6RVwoVpR6p066G6fJidQswhSj/PWOvygKjDZ1pjn/zxnQ0qiJ
         sL2j+NJB0yPOwQE6wiPII2hW9FRYRd2twa+rjEDt38gW+PcaAEGvaXQAILIju3i7fOAu
         Ltz8mylMvjFwg0Z6g009ntnCmfMaOkcv7FLoU=
MIME-Version: 1.0
In-Reply-To: <4D503A06.3010403@redhat.com>
References: <AANLkTi=gcf=A_6Kp6h7s2+OkxR4YUb6gqzc43asn-wfK@mail.gmail.com>
	<20110207174552.GC3457@thunk.org>
	<4D503A06.3010403@redhat.com>
Date: Mon, 7 Feb 2011 18:44:14 +0000
Message-ID: <AANLkTi=MPYjU4W4Zz=ajDeRAVoHCg+K68bNopgxf+DoE@mail.gmail.com>
Subject: Re: ext4: Fix data corruption with multi-block writepages support
From: Matt <jackdachef@gmail.com>
To: Milan Broz <mbroz@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 6:29 PM, Milan Broz <mbroz@redhat.com> wrote:
> On 02/07/2011 06:45 PM, Ted Ts'o wrote:
>> On Fri, Feb 04, 2011 at 10:40:47PM +0000, Matt wrote:
>>>
>>> So that means that the file-corruption which existed until 2.6.37-rc6
>>> and got triggered (for me) more easily via "dm crypt: scale to
>>> multiple CPUs"
>>> is fixed now ?
>>
>> Well, a patch exists for it that will be merged into 2.6.38.
>>
>>> That should give ext4 a nice speedup for >=2.6.38 :)
>>
>> I'm not going to make it be the default for 2.6.38, since it's fairly
>> late in the -rc features.  People who want it can explicitly enable it
>> using the mount option mblk_io_submit, though.  (And let me know your
>> success stories!  :-) I will be enabling it as the default in
>> 2.6.39-rc1.
>
> So it was ext4 only bug in ext4_end_bio(),
> dm-crypt per-cpu code was just trigger here, right?
>
> Milan
>

Hi Milan,

Well, that was at least the experience that I made

ext4: after Ted had disabled support for multiple page-io submission

I observed no data-corruption anymore (it had only appeared on the
system-partition, /home - where ext4 also is used or on my backup
partitions there was also no problem as far as I can tell)

XFS: no corruption observed

reiserfs: I can't say for sure since I'm only using it on my /boot partition :P

for other filesystems I can't say anything - I didn't use additional
ones at that time

Regards

Matt
